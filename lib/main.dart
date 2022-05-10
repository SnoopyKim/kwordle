import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/screens/main_screen.dart';
import 'package:kwordle/ui/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'KWORDLE',
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..listen())
          ],
          child: Consumer<AuthProvider>(
            builder: (context, value, child) =>
                value.user != null ? MainScreen() : SignInScreen(),
          ),
        ));
  }
}
