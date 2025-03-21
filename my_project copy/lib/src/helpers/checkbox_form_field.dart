import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {required Widget title,
      required BuildContext context,
      required FormFieldSetter<bool> onSaved,
      required FormFieldValidator<bool> validator,
      bool initialValue = false,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: state.didChange,
                subtitle: state.hasError
                    ? Text(
                        state.errorText ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
              );
            });
}
