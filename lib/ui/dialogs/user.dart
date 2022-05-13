import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLoaded
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  margin: const EdgeInsets.only(bottom: 8.0),
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
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _Record(
                                          mode: GameMode.FIVE,
                                          count: user!.five),
                                      _Record(
                                          mode: GameMode.SIX, count: user!.six),
                                      _Record(
                                          mode: GameMode.SEVEN,
                                          count: user!.seven),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: ThemeUtils.highlightColor)),
                    ),
                  ),
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
  const _Record({Key? key, required this.mode, required this.count})
      : super(key: key);

  final int mode;
  final int count;

  String getModeText() {
    switch (mode) {
      case GameMode.FIVE:
        return '다섯';
      case GameMode.SIX:
        return '여섯';
      case GameMode.SEVEN:
        return '일곱';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    const double depth = 4.0;
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: ThemeUtils.neumorphismColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            offset: Offset(depth, depth),
            color: Colors.black26,
            blurRadius: depth,
            spreadRadius: 1,
          ),
          BoxShadow(
            offset: Offset(-depth, -depth),
            color: Colors.white70,
            blurRadius: depth,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            getModeText(),
            style: const TextStyle(
                color: ThemeUtils.highlightColor,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                height: 1.0),
          ),
          const SizedBox(width: 20.0),
          // Image.asset(
          //   getImagePath(),
          //   fit: BoxFit.contain,
          //   width: 50,
          // ),
          Column(
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
    );
  }
}
