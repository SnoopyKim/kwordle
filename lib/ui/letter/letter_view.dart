import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kwordle/providers/game_provider.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

import 'letter_box.dart';

class LetterView extends StatelessWidget {
  LetterView({Key? key}) : super(key: key);

  late GameProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = context.watch();
    if (!_provider.isReadyToInput && _provider.inputHistory.isEmpty) {
      Timer(const Duration(milliseconds: 300),
          () => _provider.setReadyToInput(true));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          _provider.inputHistory.length * 2,
          (i) => i % 2 == 0
              ? LetterRow(
                  length: _provider.mode,
                  letterList: _provider.inputHistory[i ~/ 2])
              : const SizedBox(height: 6))
        ..add(AnimatedContainer(
          duration: Duration(milliseconds: _provider.isReadyToInput ? 300 : 0),
          transform: _provider.isReadyToInput
              ? Matrix4.identity()
              : Matrix4.translationValues(
                  MediaQuery.of(context).size.width * -1, 0, 0),
          child: LetterRow(
              length: _provider.mode,
              letterList: _provider.keyInputs
                  .map<Map<String, dynamic>>((e) => {'letter': e})
                  .toList()),
        )),
    );
  }
}

class LetterRow extends StatelessWidget {
  const LetterRow({Key? key, required this.length, required this.letterList})
      : super(key: key);
  final int length;
  final List<Map<String, dynamic>> letterList;

  @override
  Widget build(BuildContext context) {
    final boxSize =
        (MediaQuery.of(context).size.width - 72 - 6 * (length - 1)) / length;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(length, (i) {
          Map<String, dynamic> data =
              i < letterList.length ? letterList[i] : {};
          return LetterBox(
              index: i,
              size: boxSize,
              letter: data['letter'],
              result: data['result']);
        }));
  }
}
