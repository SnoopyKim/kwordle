import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kwordle/models/word.dart';

class ClearDialog extends StatefulWidget {
  const ClearDialog({
    Key? key,
    required this.mode,
    required this.wordIndex,
    required this.count,
    required this.onPress,
  }) : super(key: key);
  final int mode;
  final int wordIndex;
  final int count;
  final void Function() onPress;

  @override
  State<ClearDialog> createState() => _ClearDialogState();
}

class _ClearDialogState extends State<ClearDialog> {
  Word? data;

  @override
  void initState() {
    super.initState();
    DatabaseReference wordRef =
        FirebaseDatabase.instance.ref(getDatabasePath());
    wordRef.get().then((snapshot) => setState(() {
          data = Word.fromMap(snapshot.value as Map<dynamic, dynamic>);
        }));
  }

  String getDatabasePath() {
    String path = 'words';
    switch (widget.mode) {
      case 5:
        path += '/five';
        break;
      case 6:
        path += '/six';
        break;
      case 7:
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: data == null
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            data!.word,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 16.0),
                            child: Text(
                              data!.definition,
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          )
                        ],
                      )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                onPressed: () {},
                child: Text(
                  '자랑하기 [${widget.count}]',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                )),
            const SizedBox(height: 10.0),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                onPressed: () {
                  widget.onPress();
                  Navigator.pop(context);
                },
                child: const Text(
                  '다음단어',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
