import 'package:flutter/material.dart';
import '../models/route_argument.dart';
import 'package:webview_flutter/webview_flutter.dart';

class tcPrivacyPolicy extends StatelessWidget {
  final RouteArgument routeArgument;
  tcPrivacyPolicy({Key? key, required this.routeArgument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initialUrl = (routeArgument.param == "Terms")
        ? 'https://www.goprosupply.ca/terms-and-conditions-app/'
        : 'https://www.goprosupply.ca/privacy-policy-app/';

    return Scaffold(
      appBar: AppBar(
        title: routeArgument.param == "Terms"
            ? Text('Terms & Conditions')
            : Text('Privacy Policy'),
      ),
      body: Container(
        child: Text("some changes")
        // some changes
        // WebView(
        //   initialUrl: initialUrl,
        //   javascriptMode: JavascriptMode.unrestricted,
        // ),
      ),
    );
  }
}
