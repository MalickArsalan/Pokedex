import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef StringNullableFunction = String? Function(String?)?;

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required name,
    TextInputType? textInputType,
    String hintText = '',
    Widget? sufficeIconWidget,
    isObscureText = false,
    required String? Function(String?)? validatorFunction,
  })  : _name = name,
        _textInputType = textInputType,
        _hintText = hintText,
        _sufficeIconWidget = sufficeIconWidget,
        _isObscureText = isObscureText,
        _validatorFunction = validatorFunction;

  final String _name;
  final String? _hintText;
  final Widget? _sufficeIconWidget;
  final bool _isObscureText;
  final String? Function(String?)? _validatorFunction;
  final TextInputType? _textInputType;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
        name: _name,
        keyboardType: _textInputType,
        style: const TextStyle(color: Colors.cyan),
        decoration: InputDecoration(
          hintText: _hintText ?? '',
          hintStyle: const TextStyle(color: Colors.cyan),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: _hintText ?? '',
          filled: true,
          suffixIcon: _sufficeIconWidget ?? _sufficeIconWidget,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.cyan,
              width: 1.0,
            ),
          ),
        ),
        obscureText: _isObscureText,
        validator: _validatorFunction);
  }
}
