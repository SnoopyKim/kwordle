import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'name_screen.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({Key? key}) : super(key: key);

  _showLoading(BuildContext context, Future future) async {
    late BuildContext dialogContext;
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black12.withOpacity(0.6),
        pageBuilder: (_, __, ___) {
          dialogContext = context;
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: const Center(
              child: SizedBox.square(dimension: 50, child: CircularProgressIndicator()),
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
                    fontSize: 60.0, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                textAlign: TextAlign.center,
              ),
            ),
            NeumorphicButton(
              style: const NeumorphicStyle(depth: 2.0, intensity: 1.0),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const NameScreen())),
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
                                      style: const NeumorphicStyle(depth: 2, intensity: 1.0),
                                      onPressed: () => Navigator.pop(context, false),
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
                                      style: const NeumorphicStyle(depth: 2, intensity: 1.0),
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Container(
                                          width: 50,
                                          height: 20,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '예',
                                            style: TextStyle(
                                                color: ThemeUtils.highlightColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ))),
                                ],
                              )
                            ],
                          ),
                        )));
                if (result == true) {
                  _showLoading(context, context.read<AuthProvider>().withdrawal());
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
                            style: const TextStyle(color: ThemeUtils.contentColor, fontSize: 12),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                  const SelectableText('제작자 : snoopykim.dev@gmail.com',
                      style: TextStyle(color: ThemeUtils.contentColor, fontSize: 12)),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
