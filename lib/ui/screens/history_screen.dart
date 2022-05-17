import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:kwordle/models/history.dart';
import 'package:kwordle/ui/letter/simple_letter_view.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<int> modes = [GameMode.FIVE, GameMode.SIX, GameMode.SEVEN];
  int selectedMode = GameMode.FIVE;
  List<History> historyList =
      Hive.box<History>(GameUtils.getBoxName(GameMode.FIVE))
          .values
          .where((history) => history.clearTime != null)
          .toList()
          .reversed
          .toList();

  @override
  Widget build(BuildContext context) {
    double size = (MediaQuery.of(context).size.width - 40) / 3;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: NeumorphicToggle(
                height: size,
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(size / 20),
                selectedIndex: modes.indexOf(selectedMode),
                onChanged: (idx) => setState(() {
                  selectedMode = modes[idx];
                  historyList =
                      Hive.box<History>(GameUtils.getBoxName(selectedMode))
                          .values
                          .where((history) => history.clearTime != null)
                          .toList()
                          .reversed
                          .toList();
                }),
                children: [
                  ToggleElement(
                      background: const _TabText(GameMode.FIVE),
                      foreground:
                          const _TabText(GameMode.FIVE, isSelected: true)),
                  ToggleElement(
                      background: const _TabText(GameMode.SIX),
                      foreground:
                          const _TabText(GameMode.SIX, isSelected: true)),
                  ToggleElement(
                      background: const _TabText(GameMode.SEVEN),
                      foreground:
                          const _TabText(GameMode.SEVEN, isSelected: true)),
                ],
                thumb: Container(),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemBuilder: (_, i) => _HistoryCard(historyList[i]),
                  separatorBuilder: (_, i) => const SizedBox(height: 20.0),
                  itemCount: historyList.length),
            )
          ],
        ),
      ),
    );
  }
}

class _TabText extends StatelessWidget {
  const _TabText(
    this.mode, {
    Key? key,
    this.isSelected = false,
  }) : super(key: key);

  final int mode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      GameUtils.getModeText(mode),
      style: TextStyle(
        color: isSelected ? ThemeUtils.highlightColor : ThemeUtils.titleColor,
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      ),
    ));
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard(this._history, {Key? key}) : super(key: key);

  final History _history;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(depth: 4.0, intensity: 1.0),
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 240,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _history.word,
                    style: TextStyle(
                        color: ThemeUtils.titleColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _history.definition,
                    style: TextStyle(
                        color: ThemeUtils.contentColor, fontSize: 14.0),
                  ),
                  Text(
                    DateFormat('yy-MM-dd hh:mm:ss').format(_history.clearTime!),
                    style: TextStyle(
                        color: ThemeUtils.contentColor, fontSize: 14.0),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            SimpleLetterView(_history.history),
          ],
        ),
      ),
    );
  }
}
