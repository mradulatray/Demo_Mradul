import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/src/models/food.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/user.dart' as userModel;
import '../repository/user_repository.dart';
import 'BlockButtonWidget.dart';

class MobileVerificationBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final userModel.User user;

  MobileVerificationBottomSheetWidget(
      {Key? key, required this.scaffoldKey, required this.user})
      : super(key: key);

  @override
  _MobileVerificationBottomSheetWidgetState createState() =>
      _MobileVerificationBottomSheetWidgetState();
}

class _MobileVerificationBottomSheetWidgetState
    extends StateMVC<MobileVerificationBottomSheetWidget> {
  UserController? _con;
  _MobileVerificationBottomSheetWidgetState() : super(UserController()) {
    _con = controller as UserController;
  }

  String? smsSent;
  String? errorMessage;

  @override
  void initState() {
    // verifyPhone();
    super.initState();
  }

// sonu send part
  verifyPhone() async {
    currentUser.value.verificationId = '';
    smsSent = '';
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {};
    final PhoneCodeSent smsCodeSent = (String verId, int? forceCodeResent) {
      currentUser.value.verificationId = verId;
    };
    /*final PhoneVerificationCompleted _verifiedSuccess = (AuthCredential auth) {};
    final PhoneVerificationFailed _verifyFailed = (FirebaseAuthException e) {};
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.user.phone,
      timeout: const Duration(seconds: 5),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.4),
              blurRadius: 30,
              offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: ListView(
              padding:
                  EdgeInsets.only(top: 40, bottom: 15, left: 20, right: 20),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      S.of(context).verifyPhoneNumber,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    errorMessage == null
                        ? Text(
                            S
                                .of(context)
                                .weAreSendingSmsToValidateYourMobileNumberHang,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            errorMessage ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.merge(TextStyle(color: Colors.redAccent)),
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
                SizedBox(height: 30),
                TextField(
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.merge(TextStyle(letterSpacing: 15)),
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: new InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).focusColor.withOpacity(0.2)),
                    ),
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.3),
                      ),
                    ),
                    hintText: '------',
                  ),
                  onChanged: (value) {
                    this.smsSent = value;
                  },
                ),
                SizedBox(height: 15),
                Text(
                  S.of(context).smsHasBeenSentTo +
                      " " +
                      (widget.user.phone ?? ''),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80),
                BlockButtonWidget(
                  //onPressed: () async {
                  onPressed: () {
                    _con?.user = widget.user;
                    _con?.user.otp = smsSent;
                    //_con.verifyMobileOTP(_con.user);
                    //print(_con.user);
                    _con?.verifyMobileOTP((_con?.user ?? userModel.User())).then((value) {
                      if (value.success ?? false) {
                        //print("SuccessResultis==="+value.success.toString());
                        Fluttertoast.showToast(
                            msg: "Registered Sucessfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
                        Navigator.of(context).pushReplacementNamed('/Login');
                      } else {
                        Fluttertoast.showToast(
                            msg: value.message ?? '',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                    /* if(smsSent=='123456')
                    {
                      _con.verifyMobileOTP();
                     */ /*widget.user.verifiedPhone = true;
                      print("OTP_is $smsSent");
                      Navigator.of(widget.scaffoldKey.currentContext).pop();*/ /*

                    }
                    else
                    {
                      setState(() {
                        errorMessage ="Incorrect OTP,Please enter valid OTP";
                      });
                    }*/

                    //Commented by Abhinav
                    /*  User user = FirebaseAuth.instance.currentUser;
                    print(user.toString());
                    print(currentUser.value.verificationId);
                    final AuthCredential credential = PhoneAuthProvider.credential(verificationId: currentUser.value.verificationId, smsCode: smsSent);

                    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
                      currentUser.value.verifiedPhone = true;
                      widget.user.verifiedPhone = true;
                      Navigator.of(widget.scaffoldKey.currentContext).pop();
                    }).catchError((e) {
                      setState(() {
                        errorMessage = e.toString().split('\]').last;
                      });
                      print(e.toString());
                    });*/
                  },
                  color: Theme.of(context).colorScheme.secondary,
                  text: Text(S.of(context).verify.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall?.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13, horizontal: config.App(context).appWidth(42)),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
