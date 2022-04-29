import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwordle/providers/game_provider.dart';
import 'package:kwordle/providers/keyboard_provider.dart';
import 'package:kwordle/ui/keyboard/keyboard_view.dart';
import 'package:provider/provider.dart';

import '../letter/letter_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
      appBar: AppBar(title: Text('GameScreen')),
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => KeyboardProvider(),
            ),
            ChangeNotifierProvider(create: (_) => GameProvider()),
          ],
          child: Stack(
            children: [
              Column(children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Center(child: LetterView())),
                )),
                KeyboardView(
                    onUpdate: () => _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn)),
                const SizedBox(height: 30.0),
              ]),
              Selector<GameProvider, bool>(
                selector: (context, provider) => provider.isToastCalled,
                builder: (context, value, child) => value
                    ? const Align(
                        alignment: Alignment.topCenter,
                        child: Toast(),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Toast extends StatefulWidget {
  const Toast({Key? key}) : super(key: key);

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  bool isShown = false;

  @override
  void initState() {
    super.initState();
    Timer(
        Duration.zero,
        () => setState(
              () => isShown = true,
            ));
    Timer(
        const Duration(milliseconds: 2300),
        () => setState(() {
              isShown = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isShown ? 1.0 : 0.0,
            onEnd: () {
              if (!isShown) {
                context.read<GameProvider>().dismissToast();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(8.0)),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              transform: isShown
                  ? Matrix4.identity()
                  : Matrix4.translationValues(0, -20, 0),
              child: Text(
                '등록되지 않은 단어입니다',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            )));
  }
}
