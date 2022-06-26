import 'package:flutter/material.dart';
import 'package:kwordle/utils/theme_utils.dart';

class InputBox extends StatefulWidget {
  const InputBox({Key? key, required this.size, this.letter}) : super(key: key);
  final double size;
  final String? letter;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleAnim;
  late Animation<double> _scaleValue;

  @override
  void initState() {
    super.initState();
    _scaleAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleValue = Tween(begin: 1.0, end: 1.2).animate(_scaleAnim);
  }

  @override
  void dispose() {
    _scaleAnim.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InputBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool isEntered = widget.letter != null && oldWidget.letter == null;
    bool isErased = widget.letter == null && oldWidget.letter != null;
    if (isEntered || isErased) {
      _scaleAnim.forward().then((value) {
        _scaleAnim.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleValue,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: ThemeUtils.backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: widget.letter != null
                  ? ThemeUtils.titleColor
                  : ThemeUtils.contentColor,
              width: 2.0),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.letter ?? '',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: ThemeUtils.titleColor,
          ),
        ),
      ),
    );
  }
}
