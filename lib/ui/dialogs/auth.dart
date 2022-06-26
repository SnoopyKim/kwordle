import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kwordle/utils/theme_utils.dart';

class AuthDialog extends StatelessWidget {
  const AuthDialog({Key? key, required this.code}) : super(key: key);
  final int code;

  @override
  Widget build(BuildContext context) {
    String message = '';
    switch (code) {
      case 2:
        message = "이미 가입한 계정입니다.";
        break;
      case 3:
        message = "구글 계정의 문제로 로그인에 실패했습니다. 다시 시도해주세요.";
        break;
      default:
        message = '알 수 없는 오류로 인해 로그인에 실패했습니다. 다시 시도해주세요.';
    }

    return AlertDialog(
      backgroundColor: ThemeUtils.neumorphismColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: const Text(
        '로그인 실패',
        style: TextStyle(color: ThemeUtils.titleColor),
      ),
      content: Text(
        message,
        style: const TextStyle(color: ThemeUtils.contentColor),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.only(bottom: 10.0, right: 20.0),
      actions: [
        NeumorphicButton(
          style: const NeumorphicStyle(depth: 3.0, intensity: 1.0),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '확인',
            style: TextStyle(
                color: ThemeUtils.highlightColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                letterSpacing: 2.0),
          ),
        )
      ],
    );
  }
}
