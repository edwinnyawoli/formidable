import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

///
/// {
///   "type": "text"
///   "label": "Simple textfield 1",
///   "value": "1"
/// }
///
class TextFieldWidgetFactory extends WidgetFactory {
  @override
  Widget buildWidget(BuildContext context, FField field) {
    final controller = TextEditingController.fromValue(TextEditingValue(
        text: field.value.value,
        selection: TextSelection.collapsed(offset: field.value.value.length)));

    TextInputType keyboardType = TextInputType.text;
    int minLines = 1;
    int? maxLines;

    switch (field.type) {
      case "email":
        keyboardType = TextInputType.emailAddress;
        break;
      case "tel":
        keyboardType = TextInputType.phone;
        break;
      case "textarea":
        minLines = 3;
        maxLines = 4;
        break;

      default:
        keyboardType = TextInputType.text;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if ((field.label ?? '').isNotEmpty) ...[
          Text(field.label!),
          const SizedBox(height: 2)
        ],
        if (Platform.isIOS || Platform.isMacOS)
          CupertinoTextField(
            key: ValueKey(field.key),
            onChanged: (value) => field.value.value = value,
            keyboardType: keyboardType,
            maxLines: maxLines,
            minLines: minLines,
            enabled: field.isEnabled,
            placeholder: field.hint,
          )
        else
          TextField(
            key: ValueKey(field.key),
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: field.hint,
              helperText: field.helperText,
              filled: true,
              isDense: true,
              enabled: field.isEnabled,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => field.value.value = value,
            keyboardType: keyboardType,
          )
      ],
    );
  }
}
