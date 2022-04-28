import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kwordle/keyboard_provider.dart';
import 'package:kwordle/utils.dart';
import 'package:provider/provider.dart';

class LetterView extends StatelessWidget {
  LetterView({Key? key, required this.onUpdate}) : super(key: key);
  final Function() onUpdate;
  late KeyboardProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = context.watch();
    WidgetsBinding.instance?.addPostFrameCallback((_) => onUpdate());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_provider.inputHistory.length,
          (i) => LetterRow(letterList: _provider.inputHistory[i]))
        ..add(LetterRow(
            letterList: _provider.keyInputs
                .map<Map<String, dynamic>>((e) => {'letter': e})
                .toList())),
    );
  }
}

class LetterRow extends StatelessWidget {
  const LetterRow({Key? key, required this.letterList}) : super(key: key);
  final List<Map<String, dynamic>> letterList;

  @override
  Widget build(BuildContext context) {
    final boxSize = (MediaQuery.of(context).size.width - 40 - 6 * 5) / 6;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (i) {
          if (i >= letterList.length) {
            return LetterBox(size: boxSize);
          } else {
            Map<String, dynamic> data = letterList[i];
            return LetterBox(
                size: boxSize, letter: data['letter'], result: data['result']);
          }
        }));
  }
}

class LetterBox extends StatelessWidget {
  LetterBox({Key? key, required this.size, this.letter, this.result})
      : bgColor = AppUtils.getColor(result) ?? Colors.white,
        super(key: key);
  final double size;
  final String? letter;
  final int? result;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5.0),
          border: result == null
              ? Border.all(
                  color: letter != null ? Colors.black : Colors.grey.shade300,
                  width: 2.0)
              : null),
      alignment: Alignment.center,
      child: Text(
        letter ?? '',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: result != null ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
