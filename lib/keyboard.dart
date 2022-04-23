import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kwordle/keyboard_provider.dart';
import 'package:provider/provider.dart';

class KeyboardPage extends StatelessWidget {
  const KeyboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KeyboardPage')),
      body: ChangeNotifierProvider(
          create: (_) => KeyboardProvider(), child: Center(child: _KeyboardView())),
    );
  }
}

class _KeyboardView extends StatelessWidget {
  _KeyboardView({Key? key}) : super(key: key);

  final List<String> keys = ['ㅂㅈㄷㄱㅅㅛㅕㅑ', 'ㅁㄴㅇㄹㅎㅗㅓㅏㅣ', 'ㅋㅌㅊㅍㅠㅜㅡ'];

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(context.watch<KeyboardProvider>().keyInputs.join()),
      SizedBox(height: 30.0),
      ...keys.map(
        (keys) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: keys.split('').map((key) => KeyboardButton(value: key)).toList(),
          );
        },
      ).toList()
        ..add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => context.read<KeyboardProvider>().erase(), child: Text('삭제')),
            SizedBox(width: 30.0),
            ElevatedButton(
                onPressed: () => context.read<KeyboardProvider>().confirm(), child: Text('제출'))
          ],
        )),
    ]);
  }
}

class KeyboardButton extends StatefulWidget {
  const KeyboardButton({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  State<KeyboardButton> createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<KeyboardButton> {
  bool isTapDown = false;

  void setTapDown(bool value) => setState(() {
        isTapDown = value;
      });

  @override
  Widget build(BuildContext context) {
    final void Function(String) onPressKey =
        context.select((KeyboardProvider provider) => provider.input);
    return GestureDetector(
      onTapDown: (_) {
        setTapDown(true);
      },
      onTapCancel: () {
        setTapDown(false);
      },
      onTapUp: (_) {
        setTapDown(false);
        onPressKey(widget.value);
      },
      child: Container(
        decoration: BoxDecoration(
            color: isTapDown ? Colors.grey.shade300 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5.0)),
        width: 30,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        child: Text(widget.value),
      ),
    );
  }
}
