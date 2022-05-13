import 'package:flutter/material.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/dialogs/user.dart';
import 'package:kwordle/ui/screens/game_screen.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userUid = context.read<AuthProvider>().user?.uid ?? '';
    return Scaffold(
        appBar: AppBar(title: Text('KWORDLE'), actions: [
          IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => UserDialog(uid: userUid),
                  barrierDismissible: false),
              splashRadius: 28.0,
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ))
        ]),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () => navigate(context, GameMode.FIVE),
                child: Text('5글자')),
            ElevatedButton(
                onPressed: () => navigate(context, GameMode.SIX),
                child: Text('6글자')),
            ElevatedButton(
                onPressed: () => navigate(context, GameMode.SEVEN),
                child: Text('7글자')),
            ElevatedButton(
                onPressed: () => context.read<AuthProvider>().logout(),
                child: Text('로그아웃')),
          ],
        )));
  }

  Future navigate(BuildContext context, int mode) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(mode: mode),
        ));
  }
}
