import 'dart:math' as math;

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/providers/game_provider.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/theme_utils.dart';
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
    GameProvider gameProvider = context.read();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map<Widget>(
        (keys) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: keys.split('').map((key) {
              final result = GameUtils.mergeHistory(history).firstWhere(
                  (l) => l['letter'] == key,
                  orElse: () => {})['result'];
              return KeyboardButton(
                value: key,
                result: result,
              );
            }).toList(),
          );
        },
      ).toList()
        ..add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                  padding: const EdgeInsets.all(0.0),
                  style: const NeumorphicStyle(depth: 4.0, intensity: 1.0),
                  onPressed: gameProvider.erase,
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Transform.rotate(
                      angle: math.pi,
                      child: Transform.scale(
                        scaleY: 0.7,
                        child: const Icon(Icons.forward,
                            color: ThemeUtils.highlightColor, size: 40.0),
                      ),
                    ),
                  )),
              NeumorphicButton(
                  padding: const EdgeInsets.all(0.0),
                  style: const NeumorphicStyle(depth: 4.0, intensity: 1.0),
                  onPressed: () {
                    final submitResult = gameProvider.submit();
                    if (submitResult == false) {
                      gameProvider.showToast();
                    } else if (submitResult == true) {
                      gameProvider.checkClear(context, onUpdate);
                    }
                  },
                  child: SizedBox(
                      width: 100,
                      height: 50,
                      child: Transform.scale(
                        scaleY: 0.8,
                        child: const Icon(Icons.send,
                            color: ThemeUtils.highlightColor, size: 30.0),
                      ))),
            ],
          ),
        )),
    );
  }
}
