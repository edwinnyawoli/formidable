import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

class FileUploadWidgetFactory extends WidgetFactory {
  FileUploadWidgetFactory();

  @override
  Widget buildWidget(BuildContext context, FField field) {
    return FileFormField(
      field: field,
    );
  }
}

class FileFormField extends StatelessWidget {
  const FileFormField({
    Key? key,
    required this.field,
  }) : super(key: key);

  final FField field;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decorator = FileFieldDecorator.maybeOf(context);
    if (decorator == null) {
      debugPrint(
          'No FileFieldDecorator defined above FileFormField ${field.key}');
    }

    final effIcon = decorator?.icon ?? const Icon(Icons.camera_alt);
    final effPlaceholderText = (decorator?.placeholderText ?? '').isEmpty
        ? 'Tap to upload file'
        : decorator!.placeholderText!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((field.label ?? '').isNotEmpty) ...[
          Text(
            field.label!,
            style: theme.inputDecorationTheme.labelStyle,
          ),
          const SizedBox(height: 2),
        ],
        ValueListenableBuilder<String>(
          valueListenable: field.value,
          builder: ((context, path, child) {
            bool showPlaceholder = path.trim().isEmpty;

            return InkWell(
              onTap: () {
                if (WidgetsBinding.instance.lifecycleState ==
                    AppLifecycleState.resumed) {
                  decorator?.onPickFile?.call(field);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                width: decorator?.size?.width ?? double.infinity,
                height: decorator?.size?.height ??
                    (MediaQuery.of(context).size.height * 2) / 10,
                child: Stack(
                  children: [
                    if (!showPlaceholder) ...[
                      path.startsWith('http') || path.startsWith('https')
                          ? Image.network(
                              path,
                              loadingBuilder: (_, __, ___) =>
                                  const CircularProgressIndicator(),
                              errorBuilder: (_, __, ___) => IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {},
                              ),
                            )
                          : Image.file(File(path)),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: effIcon,
                        ),
                      )
                    ],
                    if (showPlaceholder)
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              effIcon,
                              const SizedBox(width: 8),
                              Text(
                                effPlaceholderText,
                                style: const TextStyle(fontSize: 16.0),
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
