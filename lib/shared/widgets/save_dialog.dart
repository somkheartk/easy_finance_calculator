import 'package:flutter/material.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';

class SavePlanDialog extends StatefulWidget {
  const SavePlanDialog({super.key, this.initialName});

  final String? initialName;

  static Future<String?> show(BuildContext context, {String? initialName}) {
    return showDialog<String>(
      context: context,
      builder: (_) => SavePlanDialog(initialName: initialName),
    );
  }

  @override
  State<SavePlanDialog> createState() => _SavePlanDialogState();
}

class _SavePlanDialogState extends State<SavePlanDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.saveCalculation),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.planName,
            hintText: l10n.enterPlanName,
          ),
          keyboardType: TextInputType.text,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  bool isDestructive = true,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: isDestructive
              ? TextButton.styleFrom(
                  foregroundColor: Theme.of(ctx).colorScheme.error,
                )
              : null,
          child: Text(confirmLabel ?? l10n.confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}
