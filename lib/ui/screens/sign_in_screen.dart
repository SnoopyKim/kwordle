import 'package:flutter/material.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/dialogs/auth.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isBusy = false;

  Future<void> signIn() async {
    setState(() {
      isBusy = true;
    });
    final resultCode = await context.read<AuthProvider>().signIn();
    if (resultCode != 1 && resultCode != 0) {
      showDialog(
          context: context, builder: (_) => AuthDialog(code: resultCode));
    }
    if (mounted) {
      setState(() {
        isBusy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isBusy
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: signIn, child: Text('google sign in')),
            )
          ],
        ),
      )),
    );
  }
}
