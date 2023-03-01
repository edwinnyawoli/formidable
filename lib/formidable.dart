library formidable;

import 'package:flutter/material.dart';
import 'package:formidable/src/field.dart';
import 'package:formidable/src/widgets/checkbox.dart';
import 'package:formidable/src/widgets/datetime.dart';
import 'package:formidable/src/widgets/dropdown.dart';
import 'package:formidable/src/widgets/file.dart';
import 'package:formidable/src/widgets/group.dart';
import 'package:formidable/src/widgets/radio.dart';
import 'package:formidable/src/widgets/textfield.dart';

export 'package:formidable/src/field.dart';
export 'package:formidable/src/decorators/file.dart';
export 'package:formidable/src/decorators/group.dart';

///
/// An abstract class extended by any class that can build a widget for
/// a given field
///
abstract class WidgetFactory {
  Widget buildWidget(BuildContext context, FField field);
}

///
/// The Parent widget through which [WidgetFactory] builders can be
/// registered
///
class FormidableApp extends InheritedWidget {
  FormidableApp({Key? key, required Widget child})
      : super(key: key, child: child) {
    final dtwf = DateTimeWidgetFactory();
    var tfwf = TextFieldWidgetFactory();
    registerWidgetFactory("group", GroupWidgetFactory(this));
    registerWidgetFactory('date', dtwf);
    registerWidgetFactory('time', dtwf);
    registerWidgetFactory('datetime', dtwf);
    registerWidgetFactory('text', tfwf);
    registerWidgetFactory('textarea', tfwf);
    registerWidgetFactory('tel', tfwf);
    registerWidgetFactory('email', tfwf);
    registerWidgetFactory('file', FileUploadWidgetFactory());
    registerWidgetFactory('checkbox', CheckboxWidgetFactory());
    registerWidgetFactory('radio', RadioWidgetFactory());
    registerWidgetFactory('dropdown', DropdownWidgetFactory());
  }

  final _factoryMap = <String, WidgetFactory Function()>{};

  static FormidableApp? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormidableApp>();
  }

  bool hasWidgetFactoryForType(String type) {
    return _factoryMap.containsKey(type);
  }

  WidgetFactory? getWidgetFactoryForTyoe(String type) {
    final factoryFunc = _factoryMap[type];
    return factoryFunc?.call();
  }

  void registerWidgetFactory(String type, WidgetFactory factory) {
    if (_factoryMap.containsKey(type)) {
      debugPrint('Duplicate WidgetFactory registration for type: $type');
    }
    _factoryMap[type] = () => factory;
  }

  Widget build(BuildContext context, FField field) {
    final factory = getWidgetFactoryForTyoe(field.type);

    if (factory == null) {
      return _UnknownFormidableFieldWidget(type: field.type);
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: factory.buildWidget(context, field),
      );
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class _UnknownFormidableFieldWidget extends StatelessWidget {
  const _UnknownFormidableFieldWidget({Key? key, required this.type})
      : super(key: key);
  final String type;

  @override
  Widget build(BuildContext context) {
    return Text('No factory has been registered for field with type: $type');
  }
}

class FormiddableColumn extends StatelessWidget {
  const FormiddableColumn(
      {Key? key, required this.fields, this.crossAxisAlignment})
      : super(key: key);
  final Iterable<FField> fields;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final formidableApp = FormidableApp.maybeOf(context);
    assert(formidableApp != null,
        'No FormidableApp widget found in context. Please wrap the app in a FormidableApp');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: fields.map((e) => formidableApp!.build(context, e)).toList(),
    );
  }
}

class FormidableListView extends StatelessWidget {
  const FormidableListView({
    Key? key,
    required this.fields,
    this.margin,
    this.shrinkWrap = true,
    this.scrollController,
  }) : super(key: key);

  final Iterable<FField> fields;
  final EdgeInsets? margin;
  final bool shrinkWrap;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final formidableApp = FormidableApp.maybeOf(context);
    assert(formidableApp != null,
        'No FormidableApp widget found in context. Please wrap the app in a FormidableApp');

    return Form(
      child: ListView.separated(
        controller: scrollController,
        shrinkWrap: shrinkWrap,
        padding: margin,
        itemCount: fields.length,
        itemBuilder: ((context, index) =>
            formidableApp!.build(context, fields.elementAt(index))),
        separatorBuilder: (context, index) =>
            SizedBox.fromSize(size: const Size.fromHeight(4)),
      ),
    );
  }
}
