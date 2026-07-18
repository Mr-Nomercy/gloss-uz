import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlossTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool filled;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final String? errorText;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;

  const GlossTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.filled = true,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.errorText,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GlossTheme>()!;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: obscureText ? 1 : maxLines,
      readOnly: readOnly,
      onTap: onTap,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      style: style ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
      cursorColor: theme.green,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: hintStyle ?? TextStyle(color: theme.disabled, fontWeight: FontWeight.w400),
        labelStyle: labelStyle ?? TextStyle(color: theme.hint, fontSize: 13, fontWeight: FontWeight.w500),
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: filled ? theme.bg : null,
        counterText: '',
        border: filled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.border),
              )
            : InputBorder.none,
        enabledBorder: filled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.border),
              )
            : InputBorder.none,
        focusedBorder: filled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.green, width: 2),
              )
            : InputBorder.none,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        isDense: true,
      ),
    );
  }
}