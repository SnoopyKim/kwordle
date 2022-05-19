import 'dart:developer';
import 'dart:math';

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
    double width = min(MediaQuery.of(context).size.width, 400);
    double size = (width - 48) / 3;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: NeumorphicButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: ThemeUtils.highlightColor,
                          size: 26.0,
                        ),
                      ),
                    ),
                    const Text(
                      '플레이 기록',
                      style: TextStyle(
                          color: ThemeUtils.titleColor,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
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
              child: SizedBox(
                width: width,
                child: historyList.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.all(24.0),
                        itemBuilder: (_, i) => _HistoryCard(historyList[i]),
                        separatorBuilder: (_, i) =>
                            const SizedBox(height: 20.0),
                        itemCount: historyList.length)
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NeumorphicIcon(
                              Icons.close,
                              style:
                                  NeumorphicStyle(depth: 2.0, intensity: 1.0),
                              size: 150,
                            ),
                            NeumorphicText(
                              '기록 없음',
                              style:
                                  NeumorphicStyle(depth: 1.0, intensity: 1.0),
                              textStyle: NeumorphicTextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
              ),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _history.word,
                  style: TextStyle(
                      color: ThemeUtils.titleColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  _history.definition,
                  style:
                      TextStyle(color: ThemeUtils.contentColor, fontSize: 14.0),
                ),
                const SizedBox(height: 20),
                Text(
                  DateFormat('yyyy-MM-dd').format(_history.clearTime!),
                  style:
                      TextStyle(color: ThemeUtils.contentColor, fontSize: 12.0),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          SimpleLetterView(_history.history, size: 150.0),
        ],
      ),
    );
  }
}
