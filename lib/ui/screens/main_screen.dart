import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/dialogs/auth.dart';
import 'package:kwordle/ui/dialogs/user.dart';
import 'package:kwordle/ui/screens/game_screen.dart';
import 'package:kwordle/ui/screens/history_screen.dart';
import 'package:kwordle/ui/screens/rank_screen.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userUid = context.read<AuthProvider>().user?.uid ?? '';
    return Scaffold(
        backgroundColor: ThemeUtils.neumorphismColor,
        appBar: NeumorphicAppBar(
          title: Container(
            height: kToolbarHeight,
            alignment: Alignment.centerLeft,
            child: Text('쿼 들',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.titleColor,
                )),
          ),
          // centerTitle: true,
          actions: [
            NeumorphicButton(
              style: NeumorphicStyle(depth: 4.0, intensity: 0.8),
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.person,
                size: 26.0,
                color: ThemeUtils.highlightColor,
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RankScreen())),
              // showDialog(
              //     context: context,
              //     builder: (_) => UserDialog(uid: userUid),
              //     barrierDismissible: false),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Neumorphic(
                  style: NeumorphicStyle(
                      depth: -5.0,
                      border: NeumorphicBorder(color: ThemeUtils.contentColor)),
                  padding: const EdgeInsets.all(30.0),
                  margin: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '김재훈',
                        style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: ThemeUtils.titleColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      _Record(mode: GameMode.FIVE, count: 0),
                      _Record(mode: GameMode.SIX, count: 0),
                      _Record(mode: GameMode.SEVEN, count: 0),
                    ],
                  ),
                ),
              ),
              const Text('플레이',
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.titleColor)),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _PlayButton(GameMode.FIVE),
                  _PlayButton(GameMode.SIX),
                  _PlayButton(GameMode.SEVEN),
                ],
              ),
              const SizedBox(height: 30.0)
            ],
          ),
        ));
  }
}

class _NameContainer extends StatefulWidget {
  _NameContainer({Key? key}) : super(key: key);

  @override
  State<_NameContainer> createState() => __NameContainerState();
}

class __NameContainerState extends State<_NameContainer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Record extends StatelessWidget {
  const _Record({Key? key, required this.mode, required this.count})
      : super(key: key);

  final int mode;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeumorphicText(
            GameUtils.getModeText(mode),
            style: NeumorphicStyle(
              depth: 2.0,
              intensity: 1.0,
            ),
            textStyle: NeumorphicTextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '시도횟수  :  $count회',
                style: const TextStyle(color: ThemeUtils.contentColor),
              ),
              const SizedBox(height: 8.0),
              Text(
                '정답개수  :  $count회',
                style: const TextStyle(color: ThemeUtils.contentColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton(
    this.mode, {
    Key? key,
  }) : super(key: key);

  final int mode;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 4.5;
    return NeumorphicButton(
      style: const NeumorphicStyle(depth: 5.0, shape: NeumorphicShape.concave),
      padding: EdgeInsets.zero,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Text(
          GameUtils.getModeText(mode),
          style: const TextStyle(
            color: ThemeUtils.highlightColor,
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(mode: mode),
          )),
    );
  }
}
