import 'package:flutter/material.dart';
import 'package:lista_sqflite/providers/database.dart';
import 'package:lista_sqflite/models/task.dart';

class TaskPage extends StatefulWidget {
  final DB database;
  final int? taskId;
  final Function()? onTaskSaved; // Adiciona o callback onTaskSaved

  TaskPage({required this.database, this.taskId, this.onTaskSaved});

  @override
  _TaskPage createState() => _TaskPage();
}

class _TaskPage extends State<TaskPage> {
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  final _taskNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

  }

  void _saveTask() async {
    final name = _taskNameController.text;
    final description = _taskDescriptionController.text;
    print("Entrou para salvar a task");

    if (name.isNotEmpty) {
      if (widget.taskId == null) {
        await widget.database.addTask(name, description); // Use a instância do banco de dados diretamente
        print("Dados adicionado: " + name + ", " + description);
      } else {
        await widget.database.updateTask(widget.taskId!, name: name, description: description);
        print("Dados alterados: " + name + ", " + description);
      }

      widget.onTaskSaved?.call(); // Chama o callback se estiver definido

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'Nova Tarefa' : 'Editar Tarefa'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: _saveTask,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _taskNameController,
                focusNode: _taskNameFocus,
                decoration: InputDecoration(labelText: 'Nome da Tarefa'),
                onChanged: (value) {
                  setState(() {
                    // _taskEdited = true; (Se precisar dessa variável, você pode descomentar)
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _taskDescriptionController,
                decoration: InputDecoration(labelText: 'Descrição da Tarefa'),
                onChanged: (value) {
                  setState(() {
                    // _taskEdited = true; (Se precisar dessa variável, você pode descomentar)
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}