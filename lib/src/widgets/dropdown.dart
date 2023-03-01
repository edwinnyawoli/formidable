import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  width: 0.0,
);
Border _kDefaultRoundedBorder = const Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

BoxDecoration _kDefaultRoundedBorderDecoration = BoxDecoration(
  color: const CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),
  border: _kDefaultRoundedBorder,
  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
);

///
/// {
///   "type": "dropdown"
///   "label": "Countries",
///   "options": ["x", "y", "z"],
///   "value": ""
/// }
///
class DropdownWidgetFactory extends WidgetFactory {
  @override
  Widget buildWidget(BuildContext context, FField field) {
    final ThemeData theme = Theme.of(context);
    final decoration = (Platform.isIOS || Platform.isMacOS)
        ? _kDefaultRoundedBorderDecoration
        : const BoxDecoration();

    return ValueListenableBuilder<String>(
      valueListenable: field.value,
      builder: (context, v, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          key: ValueKey(field.key),
          children: [
            if ((field.label ?? '').isNotEmpty) ...[
              Text(
                field.label!,
                style: theme.inputDecorationTheme.labelStyle,
              ),
              const SizedBox(height: 2),
            ],
            Container(
              decoration: decoration,
              padding: const EdgeInsets.all(6.0),
              child: DropdownButton<String>(
                value: field.options.contains(v) ? v : null,
                isExpanded: true,
                isDense: true,
                underline: const SizedBox(),
                hint: Text(field.hint ?? 'Please select'),
                items: field.options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (cv) => field.value.value = cv ?? '',
              ),
            ),
          ],
        );
      },
    );
  }
}
