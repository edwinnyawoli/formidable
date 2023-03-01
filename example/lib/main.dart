import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formidable/formidable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FormidableApp(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<Iterable<FField>> fields = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    loadJsonForm();
  }

  Future<void> loadJsonForm() async {
    final json =
        await DefaultAssetBundle.of(context).loadString('assets/form.json');
    fields.value = (jsonDecode(json)["form"]["fields"] as List)
        .map((f) => FField.fromJson(f));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder(
        valueListenable: fields,
        builder: (context, fieldsIterable, child) {
          return FormidableListView(
            fields: fieldsIterable,
            margin: const EdgeInsets.all(16),
          );
        },
      ),
    );
  }
}
