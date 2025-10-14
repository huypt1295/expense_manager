import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common/src/utils/context_utils.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.autocorrect = true,
    this.maxLength,
    this.autofillHints,
    this.readOnly = false,
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.height = 48,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final bool enabled;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autocorrect;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final bool readOnly;
  final EdgeInsetsGeometry margin;
  final double height;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.tpColors;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: colors.borderDefault),
    );

    return Padding(
      padding: margin,
      child: SizedBox(
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            obscureText: obscureText,
            enabled: enabled,
            autocorrect: autocorrect,
            maxLength: maxLength,
            autofillHints: autofillHints,
            readOnly: readOnly,
            initialValue: controller == null ? initialValue : null,
            maxLines: obscureText ? 1 : maxLines,
            minLines: minLines,
            textCapitalization: textCapitalization,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: autovalidateMode,
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.surfaceSub,
              hintText: hintText,
              labelText: labelText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: colors.borderDefault),
              ),
              disabledBorder: border,
              errorBorder: border.copyWith(
                borderSide: BorderSide(color: colors.borderDefault),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
