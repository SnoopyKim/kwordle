import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kwordle/providers/game_provider.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:provider/provider.dart';

import 'keyboard_button.dart';

class KeyboardView extends StatelessWidget {
  KeyboardView({Key? key, required this.onUpdate}) : super(key: key);

  final List<String> keys = ['ㅂㅈㄷㄱㅅㅛㅕㅑ', 'ㅁㄴㅇㄹㅎㅗㅓㅏㅣ', 'ㅋㅌㅊㅍㅠㅜㅡ'];
  final void Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    List<List<Map<String, dynamic>>> history = context.select((GameProvider p) {
      return p.inputHistory;
    });
    GameProvider _gameProvider = context.read();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map<Widget>(
        (keys) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: keys.split('').map((key) {
              final result = GameUtils.mergeHistory(history)
                  .firstWhere((l) => l['letter'] == key, orElse: () => {})['result'];
              return KeyboardButton(
                value: key,
                result: result,
              );
            }).toList(),
          );
        },
      ).toList()
        ..add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                    onPressed: _gameProvider.erase,
                    child: const Text(
                      '삭제',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 4.0,
                      ),
                    )),
              ),
              SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      double height = MediaQuery.of(context).size.height;
                      final submitResult = _gameProvider.submit();
                      if (submitResult == false) {
                        _gameProvider.showToast();
                      } else if (submitResult == true) {
                        _gameProvider.checkClear(context, onUpdate);
                      }
                    },
                    child: const Text(
                      '제출',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 4.0,
                      ),
                    )),
              )
            ],
          ),
        )),
    );
  }
}
