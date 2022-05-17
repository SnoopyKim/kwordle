import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:kwordle/models/history.dart';
import 'package:kwordle/models/word.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

// return 0: 게임종료 | 1: 다음단어
class ClearDialog extends StatefulWidget {
  const ClearDialog({
    Key? key,
    required this.mode,
    required this.wordIndex,
    required this.history,
  }) : super(key: key);
  final int mode;
  final int wordIndex;
  final List<List<Map<String, dynamic>>> history;

  @override
  State<ClearDialog> createState() => _ClearDialogState();
}

class _ClearDialogState extends State<ClearDialog> {
  Word? data;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<History>(GameUtils.getBoxName(widget.mode));
    int count = box.values.fold<int>(
        0, (previousValue, element) => previousValue + element.history.length);
    context
        .read<AuthProvider>()
        .updateUserHistory(widget.mode, box.keys.length, count);

    DatabaseReference wordRef =
        FirebaseDatabase.instance.ref(getDatabasePath());
    wordRef.get().then((snapshot) => setState(() {
          data = Word.fromMap(snapshot.value as Map<dynamic, dynamic>);

          final history = History(
              clearTime: DateTime.now(),
              word: data!.word,
              letters: data!.letters,
              definition: data!.definition,
              history: widget.history);
          box.add(history);
          box.delete('unsolved');
        }));
  }

  String getDatabasePath() {
    String path = 'words';
    switch (widget.mode) {
      case GameMode.FIVE:
        path += '/five';
        break;
      case GameMode.SIX:
        path += '/six';
        break;
      case GameMode.SEVEN:
        path += '/seven';
        break;
      default:
        path += '/six';
    }
    path += '/${widget.wordIndex}';
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ThemeUtils.neumorphismColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: 240,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: data == null
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              data!.word,
                              style: const TextStyle(
                                  color: ThemeUtils.titleColor,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 10.0),
                              child: Text(
                                '${widget.history.length}회 시도',
                                style: const TextStyle(
                                    color: ThemeUtils.contentColor,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Text(
                                data!.definition,
                                style: const TextStyle(
                                    color: ThemeUtils.contentColor,
                                    fontSize: 15.0),
                              ),
                            ),
                          ],
                        )),
              NeumorphicButton(
                  style: const NeumorphicStyle(depth: 2.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  onPressed: () {},
                  child: const Center(
                    child: Text(
                      '자랑하기',
                      style: TextStyle(
                        color: ThemeUtils.highlightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                  )),
              const SizedBox(height: 16.0),
              NeumorphicButton(
                  style: const NeumorphicStyle(depth: 2.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                  child: const Center(
                    child: Text(
                      '다음단어',
                      style: TextStyle(
                        color: ThemeUtils.highlightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  )),
              const SizedBox(height: 16.0),
              NeumorphicButton(
                  style: const NeumorphicStyle(depth: 2.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  onPressed: () {
                    Navigator.pop(context, 0);
                  },
                  child: const Center(
                    child: Text(
                      '그만하기',
                      style: TextStyle(
                        color: ThemeUtils.highlightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
