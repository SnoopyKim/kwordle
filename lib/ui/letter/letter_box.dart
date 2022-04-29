import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:kwordle/ui/letter/input_box.dart';
import 'package:kwordle/utils.dart';

class LetterBox extends StatefulWidget {
  LetterBox(
      {Key? key,
      required this.index,
      required this.size,
      this.letter,
      this.result})
      : bgColor = AppUtils.getColor(result) ?? Colors.white,
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

  // @override
  // void didUpdateWidget(covariant LetterBox oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   log('didUpdateWidget ${widget.result} ${oldWidget.result}');
  //   if (widget.result != null && oldWidget.result == null) {

  //   }
  // }

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
              margin: const EdgeInsets.all(3.0),
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
    final rotate = Tween(begin: pi, end: 0.0).animate(anim);

    return AnimatedBuilder(
        animation: rotate,
        child: widget,
        builder: (_, widget) {
          // Builder 시점 도중에 (아마 Duration 가운데) widget이 바뀌는 것으로 추정
          final isBack = ValueKey(isChanged) != widget?.key;
          var tilt = ((anim.value - 0.5).abs() - 0.5) * 0.003;
          tilt *= isBack ? -1.0 : 1.0;
          final value = isBack ? min(rotate.value, pi / 2) : rotate.value;

          return Transform(
            transform: Matrix4.rotationX(value)..setEntry(3, 0, tilt),
            child: widget,
            alignment: Alignment.center,
          );
        });
  }
}
