import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/dialogs/auth.dart';
import 'package:kwordle/utils/theme_utils.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isBusy = false;

  Future<void> signIn() async {
    setState(() {
      isBusy = true;
    });
    final resultCode = await context.read<AuthProvider>().signIn();
    if (resultCode != 1 && resultCode != 0) {
      showDialog(context: context, builder: (_) => AuthDialog(code: resultCode));
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
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicText(
              '쿼 들',
              style: const NeumorphicStyle(depth: 3.0, intensity: 1.0),
              textStyle: NeumorphicTextStyle(fontSize: 96.0, fontWeight: FontWeight.bold),
            ),
            NeumorphicButton(
              style: NeumorphicStyle(depth: isBusy ? 0.0 : 5.0),
              onPressed: signIn,
              child: Container(
                  width: 150,
                  height: 60,
                  alignment: Alignment.center,
                  child: isBusy
                      ? const CircularProgressIndicator()
                      : const Text(
                          '구글 로그인',
                          style: TextStyle(
                              fontSize: 26.0,
                              color: ThemeUtils.titleColor,
                              fontWeight: FontWeight.bold),
                        )),
            )
          ],
        ),
      )),
    );
  }
}
