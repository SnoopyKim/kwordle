import 'package:flutter/material.dart';

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
    if (widget.letter != null && oldWidget.letter == null) {
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
        margin: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: widget.letter != null
                  ? Colors.black
                  : const Color(0xFFCCCCCC),
              width: 2.0),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.letter ?? '',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
