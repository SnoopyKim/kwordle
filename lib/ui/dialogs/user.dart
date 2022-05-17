import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/models/user.dart';
import 'package:kwordle/models/word.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/theme_utils.dart';

class UserDialog extends StatefulWidget {
  const UserDialog({
    Key? key,
    required this.uid,
  }) : super(key: key);
  final String uid;

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  User? user;

  @override
  void initState() {
    super.initState();
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${widget.uid}');
    userRef.get().then((snapshot) => setState(() {
          if (snapshot.exists) {
            final data = snapshot.value as Map<dynamic, dynamic>;
            data['uid'] = widget.uid;
            user = User.fromMap(data);
          } else {
            user = User.empty();
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    bool isLoaded = user != null;
    bool isUserDataEmpty = user?.uid.isEmpty ?? false;
    return Dialog(
      backgroundColor: ThemeUtils.neumorphismColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: IntrinsicHeight(
                        child: isLoaded
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    child: Text(
                                      user!.name,
                                      style: const TextStyle(
                                          color: ThemeUtils.titleColor,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  _Record(
                                      mode: GameMode.FIVE,
                                      clear: user!.fiveClear,
                                      count: user!.fiveCount),
                                  const SizedBox(height: 16.0),
                                  _Record(
                                      mode: GameMode.SIX,
                                      clear: user!.sixClear,
                                      count: user!.sixCount),
                                  const SizedBox(height: 16.0),
                                  _Record(
                                      mode: GameMode.SEVEN,
                                      clear: user!.sevenClear,
                                      count: user!.sevenCount),
                                ],
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                        color: ThemeUtils.highlightColor)),
                              ),
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                splashRadius: 24.0,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(16.0),
                icon: const Icon(Icons.close, color: ThemeUtils.titleColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Record extends StatelessWidget {
  const _Record(
      {Key? key, required this.mode, required this.clear, required this.count})
      : super(key: key);

  final int mode;
  final int clear;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
          depth: -4.0, intensity: 0.8, shape: NeumorphicShape.concave),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            NeumorphicText(
              GameUtils.getModeText(mode),
              style: const NeumorphicStyle(depth: 2.0, intensity: 1.0),
              textStyle: NeumorphicTextStyle(
                  fontSize: 40.0, fontWeight: FontWeight.bold, height: 1.0),
            ),
            const SizedBox(width: 20.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '시도횟수 : $count회',
                  style: const TextStyle(color: ThemeUtils.titleColor),
                ),
                const SizedBox(height: 10.0),
                Text(
                  '정답개수 : $count회',
                  style: const TextStyle(color: ThemeUtils.titleColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
