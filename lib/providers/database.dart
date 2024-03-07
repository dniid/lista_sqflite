import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:lista_sqflite/models/task.dart';
import 'package:lista_sqflite/models/user.dart';

class DB {
  late Database _database;
  static DB? _instance;
  late Completer<void> _initializationCompleter;

  DB._internal() {
    _initialize();
  }

  factory DB() {
    _instance ??= DB._internal();
    return _instance!;
  }

  Future<void> _initialize() async {
    _initializationCompleter = Completer<void>();
    try {
      String databasePath = join(await getDatabasesPath(), 'sqflite.db');
      await deleteDatabase(databasePath);

      _database = await openDatabase(
        databasePath,
        onCreate: _onCreateDatabase,
        version: 1,
      );
      _initializationCompleter.complete();
    } catch (error) {
      _initializationCompleter.completeError(error);
    }
  }

  Future<void> get initializationCompleted => _initializationCompleter.future;

  void _onCreateDatabase(Database db, int version) {
    db.execute('''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT UNIQUE,
      password TEXT
    )''');

    db.execute('''
    CREATE TABLE task (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT
    )''');
  }

  Future<List<Task?>> getTasks() async {
    await initializationCompleted;
    final tasks = await _database.query('task');

    if (tasks.isEmpty) {
      return [];
    }

    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  Future<Task> getTask(int id) async {
    await initializationCompleted;
    List<Map<String, dynamic>> tasks = await _database.query(
      'task',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (tasks.isEmpty) {
      throw Exception('Task not found.');
    }

    return Task.fromMap(tasks.first);
  }

  Future<int> addTask(String name, String description) async {
    await initializationCompleted;
    return await _database.insert('task', {
      'name': name,
      'description': description,
    });
  }

  Future<int> updateTask(int id, {String name = '',  String description = ''}) async {
    await initializationCompleted;
    Map<String, dynamic> task = {
      'name': name,
      'description': description,
    };
    task.removeWhere((key, value) => value == '');
    return await _database.update('task', task, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    await initializationCompleted;
    return await _database.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<User?>> getUsers() async {
    await initializationCompleted;
    final users = await _database.query('user');

    if (users.isEmpty) {
      return [];
    }

    return users.map((user) => User.fromMap(user)).toList();
  }

  Future<User> getUser(int id) async {
    await initializationCompleted;
    List<Map<String, dynamic>> users = await _database.query(
      'user',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (users.isEmpty) {
      throw Exception('User not found.');
    }

    return User.fromMap(users.first);
  }

  Future<int> addUser(String email, String password) async {
    await initializationCompleted;
    return await _database.insert('user', {
      'email': email,
      'password': password,
    });
  }

  Future<int> updateUser(int id, {String email = '',  String password = ''}) async {
    await initializationCompleted;
    Map<String, dynamic> user = {
      'email': email,
      'password': password,
    };
    user.removeWhere((key, value) => value == '');
    return await _database.update('user', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    await initializationCompleted;
    return await _database.delete('user', where: 'id = ?', whereArgs: [id]);
  }
}
