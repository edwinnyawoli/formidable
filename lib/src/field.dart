import 'package:flutter/foundation.dart';

abstract class FField {
  static FField fromJson(Map<String, dynamic> json) => JsonFField(json);
  String get key;
  String? get label;
  String get type;
  String? get hint;
  String? get helperText;

  Iterable<String> get options;

  bool get isEnabled;

  set setEnabled(bool enabled);

  ValueNotifier<String> get value;

  Map<String, dynamic> get toJson;
}

class JsonFField extends FField {
  JsonFField(this.json) {
    value.value = json['value'] ?? '';
  }

  final Map<String, dynamic> json;
  @override
  final value = ValueNotifier<String>('');

  @override
  Iterable<String> get options =>
      (json['options'] as Iterable<dynamic>?)?.cast<String>() ?? [];

  @override
  String? get helperText => json['helperText'];

  @override
  String? get hint => json['hint'];

  @override
  bool get isEnabled => json['enabled'] ?? true;

  @override
  String get key => json['key'];

  @override
  String? get label => json['label'];

  @override
  Map<String, dynamic> get toJson => json;

  @override
  String get type => json['type'];

  @override
  set setEnabled(bool enabled) {
    json['enabled'] = enabled;
  }
}

abstract class FFieldGroup extends FField {
  Iterable<FField> get children;
}

class JsonFFieldGroup extends FFieldGroup {
  JsonFFieldGroup(this.json) {
    _children =
        (json['fields'] as Iterable<dynamic>?)?.map((e) => JsonFField(e)) ?? [];
  }

  final Map<String, dynamic> json;
  late final Iterable<FField> _children;
  @override
  final value = ValueNotifier<String>('');

  @override
  Iterable<String> get options =>
      (json['options'] as Iterable<dynamic>?)?.cast<String>() ?? [];

  @override
  String? get helperText => json['helperText'];

  @override
  String? get hint => json['hint'];

  @override
  bool get isEnabled => json['enabled'] ?? true;

  @override
  String get key => json['key'];

  @override
  String? get label => json['label'];

  @override
  Map<String, dynamic> get toJson => json;

  @override
  String get type => 'group';

  @override
  set setEnabled(bool enabled) {
    json['enabled'] = enabled;
  }

  @override
  Iterable<FField> get children => _children;
}

class SimpleFFieldGroup extends FFieldGroup {
  SimpleFFieldGroup({
    required this.children,
    this.helperText,
    this.hint,
    required this.key,
    required this.type,
    required this.value,
    this.label,
    this.enabled = false,
  });

  bool enabled;
  @override
  Iterable<String> get options => [];

  @override
  final Iterable<FField> children;

  @override
  final String? helperText;

  @override
  final String? hint;

  @override
  bool get isEnabled => enabled;

  @override
  final String key;

  @override
  final String? label;

  @override
  Map<String, dynamic> get toJson => {};

  @override
  final String type;

  @override
  final ValueNotifier<String> value;

  @override
  set setEnabled(bool enabled) {
    this.enabled = enabled;
  }
}

abstract class FValidatedField extends FField {
  FValidator get validator;

  String get validatedValue;
}

abstract class FValidator<T> {
  Future<Iterable<Object>> validate();
}
