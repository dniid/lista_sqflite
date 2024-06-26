import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:lista_sqflite/providers/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI if using Flutter Web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DB().initializationCompleted;

  // TODO: Delete later
  debugDB();

  runApp(const MainApp());
}

// TODO: Delete later
void debugDB() async {
  var database = DB();
  int userId = await database.addUser('user@email.com', 'pw');
  var user = await database.getUser(userId);
  print(user.toMap());
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
