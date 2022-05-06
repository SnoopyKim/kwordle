import 'package:flutter/material.dart';
import 'package:kwordle/providers/game_provider.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

class KeyboardButton extends StatefulWidget {
  const KeyboardButton({Key? key, required this.value, this.result}) : super(key: key);

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
    final bgColor = ThemeUtils.getColor(widget.result) ?? Colors.grey.shade200;
    final void Function(String) onPressKey =
        context.select((GameProvider provider) => provider.input);
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
            color: isTapDown ? HSLColor.fromColor(bgColor).withLightness(0.4).toColor() : bgColor,
            borderRadius: BorderRadius.circular(5.0)),
        width: (MediaQuery.of(context).size.width - 40 - 8 * 8) / 9,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        child: Text(
          widget.value,
          style: TextStyle(
              color: widget.result != null ? Colors.white : null, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
