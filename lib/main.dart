import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:lista_sqflite/providers/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI if using Flutter Web
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DB().initializationCompleted;

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
