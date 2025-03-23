import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/ModelOTPVerify.dart';
import '../models/user.dart' as model;
import '../pages/mobile_verification_2.dart';
import '../repository/user_repository.dart' as repository;
import '../models/user.dart' as userModel;
import 'package:http/http.dart' as http;

class UserController extends ControllerMVC {
  model.User user = model.User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState>? loginFormKey;
  FirebaseMessaging? _firebaseMessaging;
  OverlayEntry? loader;
  bool checkboxValue = true;
  //String userMobile="";
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  UserController() {
    loginFormKey = GlobalKey<FormState>();
    scaffoldKey = GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging?.getToken().then((String? deviceToken) {
      user.deviceToken = deviceToken ?? '';
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void login() async {
    loader = Helper.overlayLoader(safeContext);
    FocusScope.of(safeContext).unfocus();
    if (loginFormKey?.currentState?.validate() ?? false) {
      loginFormKey?.currentState?.save();
      if (loader != null) {
        Overlay.of(safeContext).insert(loader!);
      }
      repository.login(user).then((value) {
        if (scaffoldKey.currentContext != null) {
          if (value.apiToken != null) {
            Navigator.of(scaffoldKey.currentContext!)
                .pushReplacementNamed('/Pages', arguments: 1);
          } else {
            ScaffoldMessenger.of(scaffoldKey.currentContext!)
                .showSnackBar(SnackBar(
              content: Text(S.of(safeContext).wrong_email_or_password),
            ));
          }
        }
      }).catchError((e) {
        loader?.remove();
        /*  ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).this_account_not_exist),
        ));*/
      }).whenComplete(() {
        if (loader != null) {
          Helper.hideLoader(loader!);
        }
      });
    }
  }

  Future<void> verifyPhone(model.User user) async {
    autoRetrieve(String verId) {
      repository.currentUser.value.verificationId = verId;
    }

    smsCodeSent(String verId, int? forceCodeResent) {
      repository.currentUser.value.verificationId = verId;
      if (scaffoldKey.currentContext != null) {
        Navigator.push(
          scaffoldKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => MobileVerification2(
                    onVerified: (v) {
                      Navigator.of(scaffoldKey.currentContext!)
                          .pushReplacementNamed('/Pages', arguments: 2);
                    },
                  )),
        );
      }
    }

    verifiedSuccess(AuthCredential auth) {}
    verifyFailed(FirebaseAuthException e) {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(e.message ?? ''),
        ));
      }
      print(e.toString());
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: user.phone,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  void register() async {
    loader = Helper.overlayLoader(safeContext);
    FocusScope.of(safeContext).unfocus();
    if (loader != null) {
      Overlay.of(safeContext).insert(loader!);
    }
    repository.register(user).then((value) {
      if (value.apiToken != null && scaffoldKey.currentContext != null) {
        Navigator.of(scaffoldKey.currentContext!)
            .pushReplacementNamed('/Pages', arguments: 2);
      } else {
        if (scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S.of(safeContext).wrong_email_or_password),
          ));
        }
      }
    }).catchError((e) {
      loader?.remove();
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).this_email_account_exists),
        ));
      }
    }).whenComplete(() {
      if (loader != null) {
        Helper.hideLoader(loader!);
      }
    });
  }

  // by Abhinav
  // Future<userModel.User> register2() async {
  //   loader = Helper.overlayLoader(safeContext);
  //   FocusScope.of(safeContext).unfocus();
  //   Overlay.of(safeContext).insert(loader);

  //   repository.register(user).then((value) {
  //     return value;
  //   }).catchError((e) {
  //     loader.remove();
  //     if (scaffoldKey.currentContext != null) {
  //       ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
  //         content: Text(S.of(safeContext).this_email_account_exists),
  //       ));
  //     }

  //   }).whenComplete(() {
  //     Helper.hideLoader(loader);
  //   });
  // }

  Future<userModel.User> register2() async {
    loader = Helper.overlayLoader(safeContext);
    FocusScope.of(safeContext).unfocus();
    if (loader != null) {
      Overlay.of(safeContext).insert(loader!);
    }
    try {
      user = await repository.register(user);
      return user; // ✅ Ensures a return value
    } catch (e) {
      loader?.remove();
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(S.of(safeContext).this_email_account_exists),
          ),
        );
      }
      rethrow; // ✅ Re-throws the error so the caller can handle it
    } finally {
      if (loader != null) {
        Helper.hideLoader(loader!);
      }
    }
  }

  /*void verifyMobileOTP(String otp) async {
    loader = Helper.overlayLoader(safeContext);
    FocusScope.of(safeContext).unfocus();
    Overlay.of(safeContext).insert(loader);
    user.otp=otp;
    user.phone="9999999991";
    print(user.deviceToken  +"-"+ user.otp  +"-");
    repository.verifyMobileOTP(user).then((value) {
      if (value.success) {
        Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
      } else {
       */ /* ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text
            (S.of(safeContext).wrong_email_or_password),
        ));*/ /*
      }
    }).catchError((e) {
      loader.remove();
      print(e.toString());
    */ /*  ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(safeContext).this_email_account_exists),
      ));*/ /*
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }*/

  Future<ModelOTPVerify> verifyMobileOTP(userModel.User user) async {
    //user.phone=userMobile;
    print(user);
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}otp-verify';
    final client = http.Client();
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      //print(new ModelSucces.fromJson(jsonResponse));
      return ModelOTPVerify.fromJson(jsonResponse);
    } else {
      throw Exception();
    }
  }
//setti

  void resetPassword() {
    loader = Helper.overlayLoader(safeContext);
    FocusScope.of(safeContext).unfocus();
    if (loginFormKey?.currentState?.validate() ?? false) {
      loginFormKey?.currentState?.save();
      if (loader != null) {
        Overlay.of(safeContext).insert(loader!);
      }
      repository.resetPassword(user).then((value) {
        if (value == true && scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(
                S.of(safeContext).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(safeContext).login,
              onPressed: () {
                if (scaffoldKey.currentContext != null) {
                  Navigator.of(scaffoldKey.currentContext!)
                      .pushReplacementNamed('/Login');
                }
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader?.remove();
          if (scaffoldKey.currentContext != null) {
            ScaffoldMessenger.of(scaffoldKey.currentContext!)
                .showSnackBar(SnackBar(
              content: Text(S.of(safeContext).error_verify_email_settings),
            ));
          }
        }
      }).whenComplete(() {
        if (loader != null) {
          Helper.hideLoader(loader!);
        }
      });
    }
  }
}
