import 'package:flutter/material.dart';
import 'package:kwordle/utils/theme_utils.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({Key? key}) : super(key: key);

  final TextStyle contentTS =
      const TextStyle(color: ThemeUtils.contentColor, fontSize: 13.0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ThemeUtils.neumorphismColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: [
                  const Spacer(),
                  const Text(
                    '어떻게 할까?',
                    style: TextStyle(
                        color: ThemeUtils.titleColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: ThemeUtils.titleColor,
                          size: 24.0,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 24.0,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              '자모로 풀어쓴 한글 단어를 맞춰봅시다!',
              style: contentTS,
              textAlign: TextAlign.center,
            ),
            const ExampleRow([
              {'value': 'ㅍ', 'result': 2},
              {'value': 'ㅗ'},
              {'value': 'ㅎ'},
              {'value': 'ㅗ'},
              {'value': 'ㅣ'},
              {'value': 'ㄱ'},
            ]),
            Text(
              "자음 'ㅍ'은 올바른 자리에 있습니다.",
              style: contentTS,
              textAlign: TextAlign.center,
            ),
            const ExampleRow([
              {'value': 'ㅅ'},
              {'value': 'ㅅ'},
              {'value': 'ㅏ', 'result': 1},
              {'value': 'ㅇ'},
              {'value': 'ㅜ'},
              {'value': 'ㅁ'},
            ]),
            Text(
              "모음 'ㅏ'은 잘못된 자리에 있습니다.",
              style: contentTS,
              textAlign: TextAlign.center,
            ),
            const ExampleRow([
              {'value': 'ㄱ'},
              {'value': 'ㅣ'},
              {'value': 'ㅅ'},
              {'value': 'ㅡ', 'result': 0},
              {'value': 'ㄹ'},
              {'value': 'ㄱ'},
            ]),
            Text(
              "모음 'ㅡ'은 어느 곳에도 맞지 않습니다.",
              style: contentTS,
              textAlign: TextAlign.center,
            ),
            const ExampleRow([
              {'value': 'ㅇ'},
              {'value': 'ㅏ', 'highlight': true},
              {'value': 'ㅣ', 'highlight': true},
              {'value': 'ㄱ'},
              {'value': 'ㅑ', 'highlight': true},
              {'value': 'ㅣ', 'highlight': true},
            ]),
            Text(
              "복합모음과 쌍자음, 겹받침은 더 작은 자모들로 풀어집니다.",
              style: contentTS,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Text(
              '단어는 우리말샘에 등록된 2-3글자 단어 중 외래어를 제외합니다.',
              style: contentTS,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class ExampleRow extends StatelessWidget {
  const ExampleRow(this.letters, {Key? key}) : super(key: key);

  final List<Map<String, dynamic>> letters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
      child: Row(
        children: letters.map<Widget>((letter) {
          Color? bgColor = ThemeUtils.getResultColor(letter['result']);
          return Expanded(
              child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                  color: bgColor ?? ThemeUtils.backgroundColor,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      color: bgColor ?? ThemeUtils.titleColor, width: 2.0)),
              alignment: Alignment.center,
              child: Text(
                letter['value'],
                style: TextStyle(
                    color: bgColor != null
                        ? ThemeUtils.backgroundColor
                        : letter['highlight'] ?? false
                            ? const Color(0xffFF6961)
                            : ThemeUtils.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
            ),
          ));
        }).toList(),
      ),
    );
  }
}
