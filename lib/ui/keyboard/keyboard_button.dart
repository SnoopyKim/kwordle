import 'package:flutter/material.dart';
import 'package:kwordle/providers/game_provider.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

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
    final bgColor =
        ThemeUtils.getResultColor(widget.result) ?? ThemeUtils.backgroundColor;
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
            color: isTapDown ? ThemeUtils.neumorphismColor : bgColor,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: kElevationToShadow[1]),
        width: (MediaQuery.of(context).size.width - 40 - 6 * 8) / 9,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(3.0),
        child: Text(
          widget.value,
          style: TextStyle(
              color: widget.result != null
                  ? ThemeUtils.backgroundColor
                  : ThemeUtils.titleColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
