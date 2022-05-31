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

import 'name_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userUid = context.read<AuthProvider>().user?.uid ?? '';
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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RankScreen())),
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
        endDrawer: const _EndDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Neumorphic(
                  style: const NeumorphicStyle(
                      depth: -5.0,
                      border: NeumorphicBorder(color: ThemeUtils.contentColor)),
                  padding: const EdgeInsets.all(30.0),
                  margin: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Selector<AuthProvider, String?>(
                        selector: (_, provider) => provider.user?.displayName,
                        builder: (context, value, child) => Text(
                          value ?? '',
                          style: TextStyle(
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
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.titleColor)),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _PlayButton(GameMode.FIVE),
                  _PlayButton(GameMode.SIX),
                  _PlayButton(GameMode.SEVEN),
                ],
              ),
              const SizedBox(height: 30.0)
            ],
          ),
        ));
  }
}

class _EndDrawer extends StatelessWidget {
  const _EndDrawer({Key? key}) : super(key: key);

  _showLoading(BuildContext context, Future future) async {
    late BuildContext dialogContext;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: const Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                child: SizedBox.square(
                    dimension: 50, child: CircularProgressIndicator()),
              ),
            ),
          );
        });
    await future;
    Navigator.pop(dialogContext);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: ThemeUtils.neumorphismColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: NeumorphicText(
                '쿼 들',
                style: const NeumorphicStyle(depth: 2.0, intensity: 1.0),
                textStyle: NeumorphicTextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0),
                textAlign: TextAlign.center,
              ),
            ),
            NeumorphicButton(
              style: const NeumorphicStyle(depth: 2.0, intensity: 1.0),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NameScreen())),
              child: const Text(
                '이름변경',
                style: TextStyle(
                    color: ThemeUtils.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    letterSpacing: 1.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            NeumorphicButton(
              style: const NeumorphicStyle(depth: 2.0, intensity: 1.0),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              onPressed: () async {
                _showLoading(context, context.read<AuthProvider>().logout());
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(
                    color: ThemeUtils.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    letterSpacing: 1.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            NeumorphicButton(
              style: const NeumorphicStyle(depth: 2.0, intensity: 1.0),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              onPressed: () async {
                final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                        backgroundColor: ThemeUtils.neumorphismColor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '회원 탈퇴 시 모든 기록이 사라집니다. 탈퇴하시겠습니까?',
                                style: TextStyle(color: ThemeUtils.titleColor),
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NeumorphicButton(
                                      style: const NeumorphicStyle(
                                          depth: 2, intensity: 1.0),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Container(
                                          width: 50,
                                          height: 20,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '아니오',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ))),
                                  const SizedBox(width: 10),
                                  NeumorphicButton(
                                      style: const NeumorphicStyle(
                                          depth: 2, intensity: 1.0),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Container(
                                          width: 50,
                                          height: 20,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '예',
                                            style: TextStyle(
                                                color:
                                                    ThemeUtils.highlightColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ))),
                                ],
                              )
                            ],
                          ),
                        )));
                if (result == true) {
                  _showLoading(
                      context, context.read<AuthProvider>().withdrawal());
                }
              },
              child: const Text(
                '회원탈퇴',
                style: TextStyle(
                    color: ThemeUtils.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    letterSpacing: 1.0),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String version = snapshot.data!.version;
                          String buildNumber = snapshot.data!.buildNumber;
                          return Text(
                            '앱 버전 : $version ($buildNumber)',
                            style: const TextStyle(
                                color: ThemeUtils.contentColor, fontSize: 12),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                  const SelectableText('제작자 : snoopykim.dev@gmail.com',
                      style: TextStyle(
                          color: ThemeUtils.contentColor, fontSize: 12)),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _NameContainer extends StatefulWidget {
  _NameContainer({Key? key}) : super(key: key);

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
    final int count = box.values.fold<int>(
        0, (previousValue, element) => previousValue + element.history.length);
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
  }) : super(key: key);

  final int mode;

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
          )),
    );
  }
}
