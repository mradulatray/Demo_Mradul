import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/faq_category.dart';
import '../repository/faq_repository.dart';

class FaqController extends ControllerMVC {
  List<FaqCategory> faqs = <FaqCategory>[];
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  // FaqController() {
  //   scaffoldKey = new GlobalKey<ScaffoldState>();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForFaqs();
  }

  void listenForFaqs({String? message}) async {
    final Stream<FaqCategory> stream = await getFaqCategories();
    stream.listen((FaqCategory _faq) {
      setState(() {
        faqs.add(_faq);
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).verify_your_internet_connection),
        ));
      }
    }, onDone: () {
      if (message != null) {
        if (scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      }
    });
  }

  Future<void> refreshFaqs() async {
    faqs.clear();
    listenForFaqs(message: S.of(safeContext).faqsRefreshedSuccessfuly);
  }
}
