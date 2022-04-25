import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kwordle/keyboard_provider.dart';
import 'package:kwordle/letter_view.dart';
import 'package:kwordle/utils.dart';
import 'package:provider/provider.dart';

class KeyboardPage extends StatefulWidget {
  const KeyboardPage({Key? key}) : super(key: key);

  @override
  State<KeyboardPage> createState() => _KeyboardPageState();
}

class _KeyboardPageState extends State<KeyboardPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('KeyboardPage')),
      body: SafeArea(
        child: ChangeNotifierProvider(
            create: (_) => KeyboardProvider(),
            child: Column(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Center(
                        child: LetterView(
                      onUpdate: () => _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn),
                    ))),
              )),
              _KeyboardView(),
              const SizedBox(height: 30.0),
            ])),
      ),
    );
  }
}

class _KeyboardView extends StatelessWidget {
  _KeyboardView({Key? key}) : super(key: key);

  final List<String> keys = ['ㅂㅈㄷㄱㅅㅛㅕㅑ', 'ㅁㄴㅇㄹㅎㅗㅓㅏㅣ', 'ㅋㅌㅊㅍㅠㅜㅡ'];

  @override
  Widget build(BuildContext context) {
    List<List<Map<String, dynamic>>> history =
        context.select((KeyboardProvider p) {
      return p.inputHistory;
    });
    KeyboardProvider _provider = context.read();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map<Widget>(
        (keys) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: keys.split('').map((key) {
              final result = AppUtils.mergeHistory(history).firstWhere(
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                    onPressed: _provider.erase,
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
                    onPressed: _provider.submit,
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

class KeyboardButton extends StatefulWidget {
  const KeyboardButton({Key? key, required this.value, this.result})
      : super(key: key);

  final String value;
  final int? result;

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
    final bgColor = AppUtils.getColor(widget.result) ?? Colors.grey.shade200;
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
            color: isTapDown
                ? HSLColor.fromColor(bgColor).withLightness(0.4).toColor()
                : bgColor,
            borderRadius: BorderRadius.circular(5.0)),
        width: 40,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        child: Text(
          widget.value,
          style: TextStyle(
              color: widget.result != null ? Colors.white : null,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
