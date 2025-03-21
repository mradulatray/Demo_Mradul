import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';
import '../models/user.dart' as userModel;
import '../pages/mobile_verification_2.dart';
import '../repository/user_repository.dart' as repository;

class SettingsController extends ControllerMVC {
  CreditCard creditCard = new CreditCard();
  late GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void> verifyPhone(userModel.User user) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      repository.currentUser.value.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, int? forceCodeResent) {
      repository.currentUser.value.verificationId = verId;
      if (scaffoldKey.currentContext != null) {
        Navigator.push(
          scaffoldKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => MobileVerification2(
                    onVerified: (v) {
                      Navigator.of(scaffoldKey.currentContext!)
                          .pushNamed('/Settings');
                    },
                  )),
        );
      }
    };

    final PhoneVerificationCompleted _verifiedSuccess = (AuthCredential auth) {
      if (scaffoldKey.currentContext != null) {
        Navigator.of(scaffoldKey.currentContext!).pushNamed('/Settings');
      }
    };
    final PhoneVerificationFailed _verifyFailed = (FirebaseAuthException e) {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(e.message ?? ''),
        ));
      }
      print(e.toString());
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: user.phone,
      timeout: const Duration(seconds: 10),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

//sonu found
  void update(userModel.User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
      setState(() {});
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content:
              Text(S.of(safeContext).profile_settings_updated_successfully),
        ));
      }
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content:
              Text(S.of(safeContext).payment_settings_updated_successfully),
        ));
      }
    });
  }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }
}
