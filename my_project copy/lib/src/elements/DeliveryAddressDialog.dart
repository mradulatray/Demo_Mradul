import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/checkbox_form_field.dart';
import '../models/address.dart';

// ignore: must_be_immutable

/*
class DeliveryAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  DeliveryAddressDialog({this.context, this.address, this.onChanged}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
//            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.place,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  S.of(context).add_delivery_address,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _deliveryAddressFormKey,
                child: Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                      new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).home_address,
                            labelText: S.of(context).description),
                        initialValue: address.description?.isNotEmpty ?? false
                            ? address.description
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? 'Not valid address description'
                            : null,
                        onSaved: (input) => address.description = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).hint_full_address,
                            labelText: S.of(context).full_address),
                        initialValue: address.address?.isNotEmpty ?? false
                            ? address.address
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? S.of(context).notValidAddress
                            : null,
                        onSaved: (input) => address.address = input,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child:Container()
                      */ /*CheckboxFormField(
                        context: context,
                        initialValue: address.isDefault ?? true,
                        onSaved: (input) => address.isDefault = input,
                        title: Text(S.of(context).makeItDefault)*/ /*,

                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _submit,
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      onChanged(address);
      Navigator.pop(context);
    }
  }
}*/

// Handle with null address

class DeliveryAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _deliveryAddressFormKey = GlobalKey<FormState>();

  DeliveryAddressDialog({
    required this.context,
    required this.onChanged,
    required Address address,
  }) : address =
            address ?? Address(description: '', address: '', isDefault: false) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.place,
                color: Theme.of(context).hintColor,
              ),
              SizedBox(width: 10),
              Text(
                address == null
                    ? S.of(context).add_delivery_address
                    : "Edit Address",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          children: <Widget>[
            Form(
              key: _deliveryAddressFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).hintColor),
                      keyboardType: TextInputType.text,
                      decoration: getInputDecoration(
                        hintText: S.of(context).home_address,
                        labelText: S.of(context).description,
                      ),
                      initialValue: this.address.description,
                      validator: (input) => (input?.trim().isEmpty ?? true)
                          ? 'Not a valid store name'
                          : null,
                      onSaved: (input) =>
                          this.address.description = input ?? '',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).hintColor),
                      keyboardType: TextInputType.text,
                      decoration: getInputDecoration(
                        hintText: S.of(context).hint_full_address,
                        labelText: S.of(context).full_address,
                      ),
                      initialValue: this.address.address,
                      validator: (input) => (input?.trim().isEmpty ?? true)
                          ? 'Not a valid store address'
                          : null,
                      // validator: (input) => (input?.trim().isEmpty ?? true)
                      //     ? S.of(context).notValidAddress
                      //     : null,
                      onSaved: (input) => this.address.address = input ?? '',
                    ),
                  ),
                  /*CheckboxListTile(
                    title: Text(S.of(context).makeItDefault),
                    value: this.address.isDefault,
                    onChanged: (value) {
                      this.address.isDefault = value ?? false;
                    },
                  ),*/
                ],
              ),
            ),
            Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
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
      },
    );
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_deliveryAddressFormKey.currentState?.validate() ?? false) {
      _deliveryAddressFormKey.currentState?.save();
      onChanged(address);
      Navigator.pop(context);
    }
  }
}
