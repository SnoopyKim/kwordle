import 'package:flutter/material.dart';
import 'package:kwordle/ui/screens/game_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('KWORDLE')),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () => navigate(context, 5), child: Text('5글자')),
            ElevatedButton(onPressed: () => navigate(context, 6), child: Text('6글자')),
            ElevatedButton(onPressed: () => navigate(context, 7), child: Text('7글자')),
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
