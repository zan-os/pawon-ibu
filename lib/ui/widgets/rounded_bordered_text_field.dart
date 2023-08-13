import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RoundedBorderedTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool enabled;
  final bool? obsecureText;
  final TextInputType? keyboardType;
  final Function(String)? onChange;

  const RoundedBorderedTextField({
    Key? key,
    required this.label,
    this.controller,
    required this.enabled,
    this.onChange,
    this.keyboardType,
    this.obsecureText,
    this.hintText = '',
  }) : super(key: key);

  @override
  State<RoundedBorderedTextField> createState() =>
      _RoundedBorderedTextFieldState();
}

class _RoundedBorderedTextFieldState extends State<RoundedBorderedTextField> {
  late TextEditingController _textEditingController;
  late TextInputType _keyboardType;
  late bool _obsecureText;

  @override
  void initState() {
    super.initState();
    _keyboardType = widget.keyboardType ?? TextInputType.text;
    _obsecureText = widget.obsecureText ?? false;
    _textEditingController = widget.controller ?? TextEditingController();
    _textEditingController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    if (widget.onChange != null) {
      widget.onChange!(_textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: _textEditingController,
      obscureText: _obsecureText,
      keyboardType: _keyboardType,
      decoration: _inputDecoration(),
      maxLines: _obsecureText ? 1 : null,
      onChanged: (value) {
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      },
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: widget.label,
      disabledBorder: _fieldBorder(),
      enabledBorder: _fieldBorder(),
      focusedBorder: _fieldBorder(focused: true),
      filled: true,
      hintText: widget.hintText,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: greyColor),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
    );
  }

  OutlineInputBorder _fieldBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: (!focused) ? const Color(0xFFF1F4F8) : purpleColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
