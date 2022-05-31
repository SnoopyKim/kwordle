import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwordle/models/history.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/screens/main_screen.dart';
import 'package:kwordle/ui/screens/sign_in_screen.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

import 'ui/screens/name_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  await Hive.openBox('setting');
  Hive.registerAdapter(HistoryAdapter());
  await Hive.openBox<History>('history_five');
  await Hive.openBox<History>('history_six');
  await Hive.openBox<History>('history_seven');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()..listen())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'KWORDLE',
      theme: const NeumorphicThemeData(
        baseColor: ThemeUtils.neumorphismColor,
        lightSource: LightSource.topLeft,
        intensity: 0.8,
      ),
      home: Selector<AuthProvider, User?>(
          selector: (_, provider) => provider.user,
          builder: (context, user, child) {
            log(user.toString());
            return AnimatedSwitcher(
              duration: const Duration(microseconds: 300),
              child: user != null
                  ? Hive.box('setting').get('username') != null
                      ? const MainScreen()
                      : const NameScreen()
                  : const SignInScreen(),
            );
          }),
    );
  }
}
