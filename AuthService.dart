// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterubertut/main.dart';
import 'package:flutterubertut/screens/ProfileScreen.dart';
import 'package:flutterubertut/screens/VerifyNumberScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle(BuildContext context) async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    //Authentication
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User user = authResult.user!;

    assert(!user.isAnonymous);
    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);

    log(user);

    ProfileScreen(
      currentUser: user,
    ).launch(context);

    googleSignIn.signOut();
  } else {
    log(errorSomethingWentWrong);
    throw errorSomethingWentWrong;
  }
}

Future<void> loginWithOTP(BuildContext context, String phoneNumber) async {
  appStore.setLoading(true);
  return await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      appStore.setLoading(false);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        toast('The provided phone number is not valid.');
        throw 'The provided phone number is not valid.';
      } else {
        log('**************${e.toString()}');
        appStore.setLoading(false);
        toast(e.toString());
        throw e.toString();
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      //Navigator.pop(context);
      appStore.setLoading(false);
      toast("code sent");
      VerifyNumberScreen(
        verificationId: verificationId,
        phoneNo: phoneNumber,
      ).launch(context);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      appStore.setLoading(false);
    },
  );
}

