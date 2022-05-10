import 'package:flutter/material.dart';

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
      title: Text('로그인 실패'),
      content: Text(message),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(), child: Text('확인'))
      ],
    );
  }
}
