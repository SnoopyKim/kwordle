import 'dart:developer';
import 'dart:math' hide log;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:kwordle/models/history.dart';
import 'package:kwordle/models/user.dart';
import 'package:kwordle/ui/dialogs/user.dart';
import 'package:kwordle/ui/letter/simple_letter_view.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:intl/intl.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({Key? key}) : super(key: key);

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  final List<int> modes = [GameMode.FIVE, GameMode.SIX, GameMode.SEVEN];
  int selectedMode = GameMode.FIVE;

  late final List<User> users;
  bool isFetching = true;

  @override
  void initState() {
    FirebaseDatabase.instance.ref('/users').get().then((snapshot) {
      users = snapshot.children
          .map((data) => User.fromMap(data.value as Map))
          .toList();
      isFetching = false;
      _sortUsers();
    });
    super.initState();
  }

  _sortUsers() {
    users.sort((u1, u2) =>
        u2.getScore(selectedMode).compareTo(u1.getScore(selectedMode)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width, 420);
    double size = (width - 48) / 3;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: NeumorphicButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: ThemeUtils.highlightColor,
                          size: 26.0,
                        ),
                      ),
                    ),
                    const Text(
                      '순위',
                      style: TextStyle(
                          color: ThemeUtils.titleColor,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
              width: width,
              padding: const EdgeInsets.all(24.0),
              child: NeumorphicToggle(
                height: size,
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(size / 20),
                selectedIndex: modes.indexOf(selectedMode),
                onChanged: (idx) {
                  selectedMode = modes[idx];
                  _sortUsers();
                },
                children: [
                  ToggleElement(
                      background: const _TabText(GameMode.FIVE),
                      foreground:
                          const _TabText(GameMode.FIVE, isSelected: true)),
                  ToggleElement(
                      background: const _TabText(GameMode.SIX),
                      foreground:
                          const _TabText(GameMode.SIX, isSelected: true)),
                  ToggleElement(
                      background: const _TabText(GameMode.SEVEN),
                      foreground:
                          const _TabText(GameMode.SEVEN, isSelected: true)),
                ],
                thumb: Container(),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: width,
                child: !isFetching
                    ? ListView.separated(
                        padding: const EdgeInsets.all(24.0),
                        itemBuilder: (_, i) =>
                            _UserItem(i, users[i], mode: selectedMode),
                        separatorBuilder: (_, i) =>
                            const SizedBox(height: 20.0),
                        itemCount: min(users.length, 30))
                    : Center(
                        child: SizedBox.fromSize(
                        size: const Size(60, 60),
                        child: const CircularProgressIndicator(),
                      )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TabText extends StatelessWidget {
  const _TabText(
    this.mode, {
    Key? key,
    this.isSelected = false,
  }) : super(key: key);

  final int mode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      GameUtils.getModeText(mode),
      style: TextStyle(
        color: isSelected ? ThemeUtils.highlightColor : ThemeUtils.titleColor,
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      ),
    ));
  }
}

class _UserItem extends StatelessWidget {
  const _UserItem(this.rank, this.userData, {Key? key, required this.mode})
      : super(key: key);

  final int rank;
  final User userData;
  final int mode;

  @override
  Widget build(BuildContext context) {
    int clear = 0, count = 0;
    switch (mode) {
      case GameMode.FIVE:
        clear = userData.fiveClear;
        count = userData.fiveCount;
        break;
      case GameMode.SIX:
        clear = userData.sixClear;
        count = userData.sixCount;
        break;
      case GameMode.SEVEN:
        clear = userData.sevenClear;
        count = userData.sevenCount;
        break;
      default:
        break;
    }
    return SizedBox(
      height: 80,
      child: NeumorphicButton(
        onPressed: () => showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'UserDialog',
            transitionBuilder: (_, a1, a2, widget) => Transform.translate(
                offset: Offset(0, 100 * (1 - a1.value)),
                child: Opacity(opacity: a1.value, child: widget)),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return UserDialog(user: userData);
            },
            transitionDuration: const Duration(milliseconds: 300)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NeumorphicText(
              '${rank + 1}',
              style: const NeumorphicStyle(depth: 1.0, intensity: 1.0),
              textStyle: NeumorphicTextStyle(
                  fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            Text(
              userData.name,
              style: const TextStyle(
                color: ThemeUtils.titleColor,
                fontSize: 20.0,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '정답개수 : $clear',
                  style: const TextStyle(
                      color: ThemeUtils.contentColor, fontSize: 14.0),
                ),
                Text(
                  '시도횟수 : $count',
                  style: const TextStyle(
                      color: ThemeUtils.contentColor, fontSize: 14.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
