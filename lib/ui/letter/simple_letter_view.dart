import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kwordle/utils/theme_utils.dart';

class SimpleLetterView extends StatelessWidget {
  const SimpleLetterView(this.data, {Key? key, this.size = 200})
      : super(key: key);

  final double size;
  final List<List<Map<String, dynamic>>> data;

  @override
  Widget build(BuildContext context) {
    int col = data.first.length;
    return SizedBox(
      width: size,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: col,
            childAspectRatio: 1.0,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3),
        itemCount: col * data.length,
        itemBuilder: (context, idx) {
          int i = idx ~/ col;
          int j = idx % col;
          Map<String, dynamic> letterData = data[i][j];
          return _LetterBox(
            color: ThemeUtils.getResultColor(letterData['result']) ??
                ThemeUtils.titleColor,
            letter: letterData['letter'],
            fontSize: 7 + size * 0.025,
          );
        },
      ),
    );
  }
}

class _LetterBox extends StatelessWidget {
  const _LetterBox(
      {Key? key,
      required this.color,
      required this.letter,
      this.fontSize = 15.0})
      : super(key: key);

  final double fontSize;
  final Color color;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: color, width: 2.0),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
