import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/screens/name_screen.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ThemeUtils.neumorphismColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(20.0),
        child: IntrinsicHeight(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: const Text(
                      '설정',
                      style: TextStyle(
                          color: ThemeUtils.titleColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  NeumorphicButton(
                    style: NeumorphicStyle(depth: 2.0, intensity: 1.0),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NameScreen())),
                    child: Center(child: Text('이름변경')),
                  ),
                  const SizedBox(height: 20.0),
                  NeumorphicButton(
                    style: NeumorphicStyle(depth: 2.0, intensity: 1.0),
                    onPressed: () async {
                      context.read<AuthProvider>().logout();
                    },
                    child: Center(child: Text('로그아웃')),
                  ),
                  const SizedBox(height: 20.0),
                  NeumorphicButton(
                    style: NeumorphicStyle(depth: 2.0, intensity: 1.0),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Dialog(
                                backgroundColor: Colors.transparent,
                                child: Center(
                                  child: SizedBox.square(
                                      dimension: 50,
                                      child: CircularProgressIndicator()),
                                ),
                              ));
                      await Future.delayed(Duration(seconds: 2));
                      if (true) {
                        Navigator.pop(context);
                      }
                      // context.read<AuthProvider>().withdrawal();
                    },
                    child: Center(child: Text('회원탈퇴')),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: ThemeUtils.titleColor,
                  size: 24.0,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 24.0,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
