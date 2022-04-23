import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kwordle/counter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      create: (context) => Counter(),
      child: MaterialApp(
        title: 'Provider Example',
        home: const Example(),
      ),
    );
  }
}

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('build!');
    return Scaffold(
        appBar: AppBar(title: Text('Provider Example')),
        body: Center(
          child: Consumer<Counter>(
            builder: (context, counter, child) {
              return ElevatedButton(
                child: Text('현재 숫자: ${counter.count}'),
                onPressed: () {
                  counter.increment();
                },
              );
            },
          ),
        ));
  }
}
