import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  signOut() async {
    await _firebaseAuth.signOut();
  }

  Future changePassword(String currentPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);

      try {
        await user.reauthenticateWithCredential(cred);
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'too-many-requests') {
          return 'Please try again later';
        }
        if (e.code == 'wrong-password') {
          return 'Wrong password';
        }

        return;
      }
      try {
        user.updatePassword(newPassword);
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          return 'authentication error';
        }

        return;
      }
    }
  }

  //     .then((value) {
  //       user.updatePassword(newPassword).then((_) {
  //         return true;
  //       }).catchError((error) {
  //         return error;
  //       });
  //     }).catchError((err) {});
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> isLogin() async {
    _firebaseAuth.currentUser;

    var user = _firebaseAuth.currentUser;

    return user != null;
  }

  Future loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return e;
    }
  }

  Future handleSignUp({
    required String email,
    required String password,
  }) async {
    try {
      var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return user;
    } on FirebaseAuthException catch (e) {
      return e;
    } on FirebaseException catch (e) {
      return e;
    } on PlatformException catch (e) {
      return e;
    } catch (e) {
      return e;
    }
  }
}
