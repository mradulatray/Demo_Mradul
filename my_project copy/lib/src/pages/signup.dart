import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/services.dart'; // Required for input formatters
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../elements/MobileVerificationBottomSheetWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../models/user.dart' as model;

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController? _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller as UserController;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con?.scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(26),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(26) - 120,
              child: SizedBox(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(26),
                child: Text(
                  S.of(context).lets_start_with_register,
                  style: (Theme.of(context).textTheme.displayMedium ??
                          TextStyle(fontSize: 16))
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(26) - 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 50,
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      )
                    ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 28),
                width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(40),
                child: Form(
                  key: _con?.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _con?.user.name = input ?? '',
                        validator: (input) => (input?.length ?? 0) < 3
                            ? S.of(context).should_be_more_than_3_letters
                            : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).full_name,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                          contentPadding: EdgeInsets.all(12),
                          hintText: S.of(context).john_doe,
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person_outline,
                              color: Theme.of(context).colorScheme.secondary),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 26),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con?.user.email = input ?? '',
                        validator: (input) => !((input ?? '').contains('@'))
                            ? S.of(context).should_be_a_valid_email
                            : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'johndoe@gmail.com',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.alternate_email,
                              color: Theme.of(context).colorScheme.secondary),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 26),
                      TextFormField(
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        // Allow only numbers
                        onSaved: (input) => _con?.user.phone = input ?? '',
                        validator: (input) {
                          //print(input.startsWith('\+'));
                          return !((input ?? '').startsWith('00'))
                              ? "Should be 10 Digit mobile number"
                              : null;
                        },
                        decoration: InputDecoration(
                          labelText: S.of(context).phoneNumber,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                          contentPadding: EdgeInsets.all(10),
                          hintText: '(403)XXX-XXXX',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.phone_android,
                              color: Theme.of(context).colorScheme.secondary),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        obscureText: _con?.hidePassword ?? false,
                        onSaved: (input) => _con?.user.password = input ?? '',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Password cannot be empty."; // Optional: Handle empty input
                          }

                          if (input.length < 6) {
                            return S
                                .of(context)
                                .should_be_more_than_6_letters; // Length validation
                          }

                          // Regular expressions for validation
                          final bool hasAlphanumeric =
                              RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)')
                                  .hasMatch(input);
                          final bool hasSymbol =
                              RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(input);

                          if (!hasAlphanumeric) {
                            return "Should contain alpha-numeric symbol"; // Alphanumeric validation
                          }

                          if (!hasSymbol) {
                            return "Should contain alpha-numeric symbol"; // Symbol validation
                          }

                          return null; // Valid input
                        },

                        /*validator: (input) => input.length < 6
                            ? S.of(context).should_be_more_than_6_letters
                            : null,*/
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '••••••••••••',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).colorScheme.secondary),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _con?.hidePassword =
                                    !(_con?.hidePassword ?? false);
                              });
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon((_con?.hidePassword ?? false)
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 15),

                      ListTileTheme(
                        horizontalTitleGap: 0.0,
                        child: CheckboxListTile(
                          value: _con?.checkboxValue,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) {
                            setState(() {
                              _con?.checkboxValue =
                                  !(_con?.checkboxValue ?? false);
                            });
                          },
                          subtitle: !(_con?.checkboxValue ?? false)
                              ? Text(
                                  'Required',
                                  style: TextStyle(color: Colors.red),
                                )
                              : null,
                          title: GestureDetector(
                            onTap: () {
                              // Navigator.of(context).pushNamed('/TCPrivacy');
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'By clicking register, you agree to receive sms from GO PRO SUPPLY at the phone number provided. Standard rates may apply. Reply STOP to opt out.'),
                                ],
                              ),
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.green,
                        ),
                      ),
                      // Navigator.of(context).pushNamed('/Settings');
                      SizedBox(height: 15),

                      BlockButtonWidget(
                        text: Text(
                          S.of(context).register,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          if (_con?.loginFormKey?.currentState != null &&
                              (_con?.loginFormKey?.currentState!.validate() ??
                                  false) &&
                              _con?.checkboxValue == true) {
                            _con?.loginFormKey?.currentState?.save();
                            //print(_con.user);
                            _con?.register2().then((value) {
                              //print("RegisterRespons====$value");
                              var bottomSheetController = _con
                                  ?.scaffoldKey.currentState
                                  ?.showBottomSheet(
                                (context) =>
                                    MobileVerificationBottomSheetWidget(
                                        scaffoldKey: (_con?.scaffoldKey ??
                                            GlobalKey<ScaffoldState>()),
                                        user: (_con?.user ?? model.User())),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              );
                              bottomSheetController?.closed.then((value) {
                                bool mobile = _con?.user.verifiedPhone ?? false;
                                String mo = _con?.user.phone ?? '';
                                print("otpresultis  $mobile - $mo ");
                                /*   if(_con.user.verifiedPhone==true)
                                                      _con.register();*/
                              });
                            });
                          }

                          /*  if (_con.loginFormKey.currentState.validate()) {
                            _con.loginFormKey.currentState.save();
                            var bottomSheetController = _con.scaffoldKey.currentState.showBottomSheet(
                                  (context) => MobileVerificationBottomSheetWidget(scaffoldKey: _con.scaffoldKey, user: _con.user),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                            );
                            bottomSheetController.closed.then((value) {
                              bool mobile=_con.user.verifiedPhone;
                              String mo=_con.user.phone;
                              print("otpresultis  $mobile - $mo ");
                              if(_con.user.verifiedPhone==true)
                               _con.register();
                            });
                          }*/
                        },
                      ),
                      SizedBox(height: 26),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey, fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamed('/Terms',
                                        arguments:
                                            RouteArgument(param: 'Terms'));
                                  }),
                            TextSpan(text: ' | '),
                            TextSpan(
                                text: 'Privacy Policy.',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamed('/Privacy',
                                        arguments:
                                            RouteArgument(param: 'Privacy'));
                                    // print('Privacy Policy"');
                                  }),
                          ],
                        ),
                      ),
//                      MaterialButton(
//      elevation: 0,
//      focusElevation: 0,
//      highlightElevation: 0,
//                        onPressed: () {
//                          Navigator.of(context).pushNamed('/MobileVerification');
//                        },
//                        padding: EdgeInsets.symmetric(vertical: 14),
//                        color: Theme.of(context).accentColor.withOpacity(0.1),
//                        shape: StadiumBorder(),
//                        child: Text(
//                          'Register with Google',
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: MaterialButton(
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                onPressed: () {
                  Navigator.of(context).pushNamed('/Login');
                },
                textColor: Theme.of(context).hintColor,
                child: Text(S.of(context).i_have_account_back_to_login),
              ),
            )
          ],
        ),
      ),
    );
  }
}
