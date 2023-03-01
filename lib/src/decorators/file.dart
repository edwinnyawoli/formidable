import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

class FileFieldDecorator extends InheritedWidget {
  const FileFieldDecorator({
    Key? key,
    required Widget child,
    this.onPickFile,
    this.placeholderText,
    this.icon,
    this.size,
  }) : super(key: key, child: child);

  final String? placeholderText;
  final Widget? icon;
  final Size? size;
  final Future<void> Function(FField field)? onPickFile;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      onPickFile != (oldWidget as FileFieldDecorator).onPickFile;

  static FileFieldDecorator? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FileFieldDecorator>();
  }
}
