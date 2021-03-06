import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwordle/models/user.dart' as model;
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/utils/hive_utils.dart';

class AuthProvider with ChangeNotifier {
  User? user;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  DatabaseReference userRef = FirebaseDatabase.instance.ref('users');

  void listen() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user == null) {
      } else {
        await HiveUtils().configBox(user.uid);
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
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken,
          idToken: googleAuthentication.idToken,
        ));
        if (userCredential.additionalUserInfo?.isNewUser ?? true) {
          createUserData(userCredential.user);
        } else {
          await Hive.box('setting').put('username', userCredential.user?.displayName);
        }
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
      return -1;
    }
  }

  createUserData(User? user) async {
    if (user == null) return;
    userRef.child(user.uid).set(
        model.User.register(email: user.email ?? '', name: user.displayName ?? '').toMap()
          ..remove('uid'));
  }

  Future<void> _updateUserData(String uid, Map<String, dynamic> data) async {
    await userRef.child(uid).update(data);
  }

  Future<void> updateUserName(String name) async {
    if (user == null) return;
    await user!.updateDisplayName(name);
    user!.reload();
    await _updateUserData(user!.uid, {'name': name});
  }

  Future<void> updateUserHistory(int mode, int clear, int count) async {
    if (user == null) return;
    String modeText = GameUtils.getModeText(mode, isEng: true);
    await _updateUserData(user!.uid, {
      '${modeText}Clear': clear,
      '${modeText}Count': count,
    });
  }

  Future logout() async {
    await Hive.box('setting').delete('username');
    await HiveUtils().closeBox();
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  Future withdrawal() async {
    if (user == null) return;
    await userRef.child(user!.uid).remove();
    await HiveUtils().clearBox();
    final googleAccount = await _googleSignIn.signInSilently();
    final googleAuth = await googleAccount?.authentication;
    await user!.reauthenticateWithCredential(GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken));
    await user!.delete();
    await logout();
  }
}
