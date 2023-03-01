import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

///
/// {
///   "type": "radio"
///   "label": "",
///   "options": ["1", "2", "3"],
///   "value": "1"
/// }
///
class RadioWidgetFactory extends WidgetFactory {
  @override
  Widget buildWidget(BuildContext context, FField field) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<String>(
      valueListenable: field.value,
      builder: (context, v, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((field.label ?? '').isNotEmpty) ...[
              Text(field.label!),
              const SizedBox(height: 2)
            ],
            ...field.options
                .map(
                  (o) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Radio<String>(
                          value: o,
                          groupValue: v,
                          onChanged: ((value) =>
                              field.value.value = value ?? ''),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(o))
                    ],
                  ),
                )
                .toList(),
          ],
        );
      },
    );
  }
}
