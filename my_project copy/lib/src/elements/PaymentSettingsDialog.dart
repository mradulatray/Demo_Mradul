import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';

// ignore: must_be_immutable
class PaymentSettingsDialog extends StatefulWidget {
  CreditCard creditCard;
  VoidCallback onChanged;

  PaymentSettingsDialog(
      {Key? key, required this.creditCard, required this.onChanged})
      : super(key: key);

  @override
  _PaymentSettingsDialogState createState() => _PaymentSettingsDialogState();
}

class _PaymentSettingsDialogState extends State<PaymentSettingsDialog> {
  GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      S.of(context).payment_settings,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _paymentSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '4242 4242 4242 4242',
                              labelText: S.of(context).number),
                          initialValue:
                              (widget.creditCard.number?.isNotEmpty ?? false)
                                  ? widget.creditCard.number
                                  : null,
                          validator: (input) => input?.trim().length != 16
                              ? S.of(context).not_a_valid_number
                              : null,
                          onSaved: (input) =>
                              widget.creditCard.number = input ?? '',
                        ),
                        new TextFormField(
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(
                                hintText: 'mm/yy',
                                labelText: S.of(context).exp_date),
                            initialValue:
                                (widget.creditCard.expMonth?.isNotEmpty ??
                                        false)
                                    ? (widget.creditCard.expMonth ?? '') +
                                        '/' +
                                        (widget.creditCard.expYear ?? '')
                                    : null,
                            // TODO validate date

                            validator: (input) =>
                                !(input ?? '').contains('/') ||
                                        (input ?? '').length != 5
                                    ? S.of(context).not_a_valid_date
                                    : null,
                            onSaved: (input) {
                              widget.creditCard.expMonth =
                                  (input ?? '').split('/').elementAt(0);
                              widget.creditCard.expYear =
                                  (input ?? '').split('/').elementAt(1);
                            }),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '253', labelText: S.of(context).cvc),
                          initialValue:
                              (widget.creditCard.cvc?.isNotEmpty ?? false)
                                  ? widget.creditCard.cvc
                                  : null,
                          validator: (input) => (input ?? '').trim().length != 3
                              ? S.of(context).not_a_valid_cvc
                              : null,
                          onSaved: (input) =>
                              widget.creditCard.cvc = input ?? '',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).cancel),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          S.of(context).save,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_paymentSettingsFormKey.currentState?.validate() ?? false) {
      _paymentSettingsFormKey.currentState?.save();
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
