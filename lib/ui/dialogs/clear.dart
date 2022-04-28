import 'package:flutter/material.dart';

class ClearDialog extends StatelessWidget {
  const ClearDialog(
      {Key? key,
      required this.wordIndex,
      required this.count,
      required this.onPress})
      : super(key: key);
  final String mode = 'six';
  final int wordIndex;
  final int count;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('성공!'),
      content: Text('$wordIndex\n시도횟수: $count'),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              onPress();
              Navigator.pop(context);
            },
            child: Text('다음 단어'))
      ],
    );
  }
}
