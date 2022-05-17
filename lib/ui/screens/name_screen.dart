import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  late TextEditingController _tec;
  late AuthProvider _authProvider;
  late String _initialName;

  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    _initialName = _authProvider.user?.displayName ?? '';
    _tec = TextEditingController(text: _initialName);
  }

  Future<void> saveUserName(String name) async {
    if (_initialName != name) {
      setState(() {
        isBusy = true;
      });
      await Hive.box('setting').put('username', name);
      await _authProvider.updateUserName(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "닉네임 설정",
                style: TextStyle(
                  color: ThemeUtils.titleColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Neumorphic(
                style: const NeumorphicStyle(
                    depth: -4.0,
                    intensity: 1.0,
                    shape: NeumorphicShape.concave),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _tec,
                  style: const TextStyle(color: ThemeUtils.titleColor),
                  decoration: const InputDecoration(border: InputBorder.none),
                  cursorColor: ThemeUtils.titleColor,
                  onSubmitted: saveUserName,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                '💡 구글 계정의 이름이 기본값으로 설정됩니다.',
                style:
                    TextStyle(color: ThemeUtils.contentColor, fontSize: 13.0),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: NeumorphicButton(
                    style: NeumorphicStyle(depth: isBusy ? 0.0 : 4.0),
                    onPressed: () => saveUserName(_tec.text),
                    child: Container(
                      width: 60,
                      height: 30,
                      alignment: Alignment.center,
                      child: isBusy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                          : const Text(
                              '확인',
                              style: TextStyle(
                                  color: ThemeUtils.highlightColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
