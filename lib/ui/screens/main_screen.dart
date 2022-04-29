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
            ElevatedButton(
                onPressed: () => navigate(context),
                child: Text('KEYBOARD PAGE'))
          ],
        )));
  }

  Future navigate(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(),
        ));
  }
}
