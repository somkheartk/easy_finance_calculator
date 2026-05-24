import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.suffix,
    this.prefix,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled = true,
    this.helperText,
    this.maxLines = 1,
    this.autofocus = false,
  });

  final String label;
  final String? hint;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  final String? helperText;
  final int maxLines;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ??
          const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffix,
        prefixIcon: prefix,
        helperText: helperText,
      ),
    );
  }
}

class NumericTextField extends StatelessWidget {
  const NumericTextField({
    super.key,
    required this.label,
    this.hint,
    this.suffix,
    this.controller,
    this.validator,
    this.onChanged,
    this.allowDecimal = true,
    this.enabled = true,
    this.helperText,
  });

  final String label;
  final String? hint;
  final String? suffix;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool allowDecimal;
  final bool enabled;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint ?? '0',
      suffix: suffix != null ? _SuffixLabel(suffix!) : null,
      controller: controller,
      enabled: enabled,
      helperText: helperText,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'^\d+\.?\d{0,4}') : RegExp(r'^\d+'),
        ),
      ],
      validator: validator,
      onChanged: onChanged,
    );
  }
}

class _SuffixLabel extends StatelessWidget {
  const _SuffixLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
