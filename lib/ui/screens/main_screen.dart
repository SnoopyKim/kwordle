import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwordle/models/history.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/screens/game_screen.dart';
import 'package:kwordle/ui/screens/rank_screen.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/hive_utils.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'end_drawer.dart';
import 'name_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeUtils.neumorphismColor,
        appBar: NeumorphicAppBar(
          automaticallyImplyLeading: false,
          title: Container(
            height: kToolbarHeight,
            alignment: Alignment.centerLeft,
            child: const Text('쿼 들',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.titleColor,
                )),
          ),
          actionSpacing: 20,
          actions: [
            NeumorphicButton(
              style: const NeumorphicStyle(depth: 4.0, intensity: 0.8),
              padding: EdgeInsets.zero,
              child: const Icon(
                Icons.leaderboard_rounded,
                size: 26.0,
                color: ThemeUtils.highlightColor,
              ),
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RankScreen())),
            ),
            Builder(builder: (context) {
              return NeumorphicButton(
                  style: const NeumorphicStyle(depth: 4.0, intensity: 0.8),
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.settings_rounded,
                    size: 26.0,
                    color: ThemeUtils.highlightColor,
                  ),
                  onPressed: () => Scaffold.of(context).openEndDrawer());
            })
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: const EndDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Neumorphic(
                  style: const NeumorphicStyle(
                      depth: -5.0, border: NeumorphicBorder(color: ThemeUtils.contentColor)),
                  padding: const EdgeInsets.all(30.0),
                  margin: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Selector<AuthProvider, String?>(
                        selector: (_, provider) => provider.user?.displayName,
                        builder: (context, value, child) => Text(
                          value ?? '',
                          style: const TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: ThemeUtils.titleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      _Record(mode: GameMode.FIVE),
                      _Record(mode: GameMode.SIX),
                      _Record(mode: GameMode.SEVEN),
                    ],
                  ),
                ),
              ),
              const Text('플레이',
                  style: TextStyle(
                      fontSize: 26.0, fontWeight: FontWeight.bold, color: ThemeUtils.titleColor)),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PlayButton(GameMode.FIVE, refresh: refresh),
                  _PlayButton(GameMode.SIX, refresh: refresh),
                  _PlayButton(GameMode.SEVEN, refresh: refresh),
                ],
              ),
              const SizedBox(height: 30.0)
            ],
          ),
        ));
  }

  void refresh() => setState(() {});
}

class _NameContainer extends StatefulWidget {
  const _NameContainer({Key? key}) : super(key: key);

  @override
  State<_NameContainer> createState() => __NameContainerState();
}

class __NameContainerState extends State<_NameContainer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Record extends StatelessWidget {
  _Record({Key? key, required this.mode})
      : box = HiveUtils().getBox(mode),
        super(key: key);

  final int mode;
  late final Box<History> box;

  @override
  Widget build(BuildContext context) {
    final bool isUnsolvedExist = box.containsKey('unsolved');
    final int clear = isUnsolvedExist ? box.length - 1 : box.length;
    final int count =
        box.values.fold<int>(0, (previousValue, element) => previousValue + element.history.length);
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeumorphicText(
            GameUtils.getModeText(mode),
            style: const NeumorphicStyle(
              depth: 2.0,
              intensity: 1.0,
            ),
            textStyle: NeumorphicTextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '정답개수  :  $clear회',
                style: const TextStyle(color: ThemeUtils.contentColor),
              ),
              const SizedBox(height: 8.0),
              Text(
                '시도횟수  :  $count회',
                style: const TextStyle(color: ThemeUtils.contentColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton(
    this.mode, {
    Key? key,
    required this.refresh,
  }) : super(key: key);

  final int mode;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 4.5;
    return NeumorphicButton(
      style: const NeumorphicStyle(depth: 5.0, shape: NeumorphicShape.concave),
      padding: EdgeInsets.zero,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Text(
          GameUtils.getModeText(mode),
          style: const TextStyle(
            color: ThemeUtils.highlightColor,
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(mode: mode),
          )).then((value) => refresh()),
    );
  }
}
