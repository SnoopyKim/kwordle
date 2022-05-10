import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  User? user;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  void listen() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        log('No user data');
      } else {
        log('User signed in!');
      }
      this.user = user;
      notifyListeners();
    });
  }

  // -1: 알 수 없는 실패, 0: 취소, 1: 성공, 2: 이미 가입, 3: 구글 계정 문제
  Future<int> signIn() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final googleAuthentication = await googleSignInAccount.authentication;
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken,
          idToken: googleAuthentication.idToken,
        ));
        return userCredential.user != null ? 1 : -1;
      } else {
        return 0;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return 2;
        case 'invalid-credential':
          return 3;
        default:
          return -1;
      }
    } catch (err) {
      log('[GOOGLE SIGN IN ERROR]\n$err');
      return -1;
    }
  }

  void logout() {
    _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
