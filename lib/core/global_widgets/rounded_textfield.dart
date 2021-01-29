import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String errorText;
  final bool isObsecure;
  final bool isReadOnly;
  final Function onTap;

  final TextInputType keyboardType;
  final Function(String value) validateRules;

  RoundedTextField(
      {this.labelText,
      this.hintText,
      this.errorText,
      this.isObsecure,
      this.isReadOnly,
      this.keyboardType,
      this.validateRules,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        onTap?.call();
      },
      obscureText: this.isObsecure,
      keyboardType: keyboardType ?? TextInputType.text,
      readOnly: isReadOnly ?? false,
      decoration: InputDecoration(
        labelText: this.labelText,
        hintText: this.hintText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        return validateRules?.call(value);
      },
    );
  }
}
