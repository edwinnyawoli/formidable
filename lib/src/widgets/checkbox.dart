import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

///
/// {
///   "type": "checkbox"
///   "label": "Agree?",
///   "value": "false"
/// }
///
class CheckboxWidgetFactory extends WidgetFactory {
  @override
  Widget buildWidget(BuildContext context, FField field) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<String>(
      valueListenable: field.value,
      builder: (context, v, child) {
        return Row(
          children: <Widget>[
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: v.toLowerCase() == 'true',
                onChanged: (bool? value) {
                  field.value.value = value?.toString() ?? 'false';
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              field.label ?? '',
              style: theme.inputDecorationTheme.labelStyle,
            )
          ],
        );
      },
    );
  }
}
