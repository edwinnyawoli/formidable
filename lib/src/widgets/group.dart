import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

class GroupWidgetFactory extends WidgetFactory {
  final FormidableApp app;

  GroupWidgetFactory(this.app);

  @override
  Widget buildWidget(BuildContext context, FField field) {
    final fieldGroup = field as FFieldGroup;
    final decorator = FieldGroupDecorator.maybeOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((field.label ?? '').isNotEmpty &&
              (decorator?.showLabel ?? true)) ...[
            Text(field.label!, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8)
          ],
          if ((field.helperText ?? '').isNotEmpty &&
              (decorator?.showHelperText ?? true)) ...[
            Text(field.helperText!, style: Theme.of(context).textTheme.caption),
            const SizedBox(height: 12)
          ],
          ...fieldGroup.children.map((e) => app.build(context, e)).toList()
        ],
      ),
    );
  }
}
