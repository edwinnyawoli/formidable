import 'package:flutter/material.dart';

class FieldGroupDecorator extends InheritedWidget {
  const FieldGroupDecorator({
    Key? key,
    required Widget child,
    this.showLabel,
    this.showHelperText,
  }) : super(key: key, child: child);

  final bool? showLabel;
  final bool? showHelperText;

  @override
  bool updateShouldNotify(FieldGroupDecorator oldWidget) =>
      showLabel != oldWidget.showLabel;

  static FieldGroupDecorator? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FieldGroupDecorator>();
  }
}
