import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/providers/game_provider.dart';
import 'package:kwordle/ui/dialogs/help.dart';
import 'package:kwordle/ui/keyboard/keyboard_view.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

import '../letter/letter_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.mode}) : super(key: key);

  final int mode;

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
      backgroundColor: ThemeUtils.neumorphismColor,
      appBar: NeumorphicAppBar(
        leading: NeumorphicButton(
          style: NeumorphicStyle(depth: 4.0, intensity: 0.8),
          child: Icon(
            Icons.arrow_back,
            color: ThemeUtils.highlightColor,
            size: 26.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          NeumorphicButton(
            style: NeumorphicStyle(depth: 4.0, intensity: 0.8),
            child: Icon(
              Icons.help_outline,
              color: ThemeUtils.highlightColor,
              size: 26.0,
            ),
            onPressed: () => showDialog(
                context: context, builder: (_) => const HelpDialog()),
          )
        ],
      ),
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => GameProvider(widget.mode),
            ),
          ],
          child: Stack(
            children: [
              Column(children: [
                Expanded(
                    child: Neumorphic(
                  margin: const EdgeInsets.all(20.0),
                  style: NeumorphicStyle(
                      depth: -4.0, shape: NeumorphicShape.concave),
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      controller: _scrollController,
                      child: LetterView()),
                )),
                KeyboardView(
                    onUpdate: () => _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn)),
                const SizedBox(height: 20.0)
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
    return AnimatedOpacity(
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
              color: Color(0xffFF6961),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: kElevationToShadow[2]),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          transform: isShown
              ? Matrix4.identity()
              : Matrix4.translationValues(0, -20, 0),
          child: const Text(
            '등록되지 않은 단어입니다',
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}
