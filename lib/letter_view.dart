import 'package:flutter/material.dart';
import 'package:kwordle/keyboard_provider.dart';
import 'package:provider/provider.dart';

class LetterView extends StatelessWidget {
  LetterView({Key? key}) : super(key: key);

  late KeyboardProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = context.watch();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          _provider.inputHistory.length,
          (i) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_provider.inputHistory[i].length, (j) {
                  Map<String, dynamic> data = _provider.inputHistory[i][j];
                  return LetterBox(
                      letter: data['letter'], result: data['result']);
                }),
              ))
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (i) {
          if (i >= letterList.length) {
            return LetterBox();
          } else {
            Map<String, dynamic> data = letterList[i];
            return LetterBox(letter: data['letter'], result: data['result']);
          }
        }));
  }
}

class LetterBox extends StatelessWidget {
  LetterBox({Key? key, this.letter, this.result})
      : bgColor = (() {
          switch (result) {
            case 0:
              return Colors.blueGrey;
            case 1:
              return Colors.green;
            case 2:
              return Colors.orangeAccent;
            default:
              return Colors.white;
          }
        })(),
        super(key: key);
  final String? letter;
  final int? result;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
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
