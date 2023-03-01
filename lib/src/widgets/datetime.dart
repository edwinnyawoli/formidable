import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

///
/// A widget factory for 'date', 'time' and 'datetime' fields
///
class DateTimeWidgetFactory extends WidgetFactory {
  @override
  Widget buildWidget(BuildContext context, FField field) {
    switch (field.type) {
      case 'date':
        return _DatePicker(field: field);
      case 'time':
        return _TimePicker(field: field);
      case 'datetime':
        return _DatePicker(field: field);
      default:
        return const SizedBox();
    }
  }
}

class _TimePicker extends StatelessWidget {
  _TimePicker({Key? key, required this.field}) : super(key: key);
  final FField field;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (field.isEnabled) {
          final dateTime = DateTime.tryParse(field.value.value);
          final initialTime = dateTime != null
              ? TimeOfDay.fromDateTime(dateTime)
              : TimeOfDay.now();
          final timeOfDay =
              await showTimePicker(context: context, initialTime: initialTime);
          if (timeOfDay != null) {
            field.value.value = timeOfDay.toString();
            controller.text = field.value.value;
          }
        }
      },
      child: AbsorbPointer(
        child: Stack(
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: '',
                counterText: '',
                filled: true,
                enabled: field.isEnabled,
                isDense: true,
                border: const OutlineInputBorder(),
              ),
              readOnly: true,
              maxLength: 10,
              keyboardType: TextInputType.number,
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 12.0, right: 8.0),
                child: Icon(Icons.timer_sharp),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  _DatePicker({Key? key, required this.field}) : super(key: key);
  final FField field;
  static const hundredYears = Duration(days: 365 * 100);
  final controller = TextEditingController();

  Future<DateTime?> _showCupertinoDatePicker(
    BuildContext context, {
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
  }) async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isDismissible: false,
      builder: (BuildContext ctx) {
        DateTime? selectedDateTime = initialDate;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          height: 330,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if ((field.helperText ?? '').isNotEmpty)
                  Text(
                    field.helperText!,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    minimumDate: firstDate,
                    maximumDate: lastDate,
                    onDateTimeChanged: (DateTime value) {
                      selectedDateTime = value;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context, selectedDateTime);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result is DateTime) {
      return result;
    } else {
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked;
    bool useCupertinoDialog = 1 != 1;
    if ((Platform.isIOS || Platform.isMacOS) && useCupertinoDialog) {
      picked = await _showCupertinoDatePicker(context);
    } else {
      final initialDate =
          DateTime.tryParse(field.value.value) ?? DateTime.now();
      picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: initialDate.subtract(hundredYears),
        lastDate: initialDate.add(hundredYears),
        helpText: field.helperText,
      );
    }

    if (picked != null) {
      field.value.value = picked.toIso8601String();
      controller.text = field.value.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (field.isEnabled) {
          _selectDate(context);
        }
      },
      child: AbsorbPointer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if ((field.label ?? '').isNotEmpty) ...[
              Text(field.label!),
              const SizedBox(height: 2)
            ],
            if (Platform.isIOS || Platform.isMacOS)
              CupertinoTextField(
                controller: controller,
                key: ValueKey(field.key),
                onChanged: (value) => field.value.value = value,
                keyboardType: TextInputType.datetime,
                enabled: field.isEnabled,
                placeholder: field.hint,
                readOnly: true,
                suffix: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.calendar_today),
                ),
              )
            else
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: field.hint,
                  helperText: field.helperText,
                  filled: true,
                  isDense: true,
                  enabled: field.isEnabled,
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
                keyboardType: TextInputType.datetime,
              ),
          ],
        ),
      ),
    );
  }
}
