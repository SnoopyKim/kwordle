import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kwordle/ui/letter/input_box.dart';
import 'package:kwordle/utils/theme_utils.dart';

class LetterBox extends StatefulWidget {
  LetterBox(
      {Key? key,
      required this.index,
      required this.size,
      this.letter,
      this.result})
      : bgColor =
            ThemeUtils.getResultColor(result) ?? ThemeUtils.backgroundColor,
        super(key: key);
  final int index;
  final double size;
  final String? letter;
  final int? result;
  final Color bgColor;

  @override
  State<LetterBox> createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.result != null) {
      Timer(
        Duration(milliseconds: 200 * widget.index),
        () => setState(() {
          isChanged = true;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: flipAnimBuilder,
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear.flipped,
      layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
      child: isChanged
          ? Container(
              key: const ValueKey(true),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: widget.bgColor, width: 2.0),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.letter!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : InputBox(
              key: const ValueKey(false),
              size: widget.size,
              letter: widget.letter),
    );
  }

  Widget flipAnimBuilder(Widget widget, Animation<double> anim) {
    final rotate = Tween(begin: math.pi, end: 0.0).animate(anim);

    return AnimatedBuilder(
        animation: rotate,
        child: widget,
        builder: (_, widget) {
          // Builder ?????? ????????? (?????? Duration ?????????) widget??? ????????? ????????? ??????
          final isBack = ValueKey(isChanged) != widget?.key;
          var tilt = ((anim.value - 0.5).abs() - 0.5) * 0.003;
          tilt *= isBack ? -1.0 : 1.0;
          final value =
              isBack ? math.min(rotate.value, math.pi / 2) : rotate.value;

          return Transform(
            transform: Matrix4.rotationX(value)..setEntry(3, 0, tilt),
            alignment: Alignment.center,
            child: widget,
          );
        });
  }
}
