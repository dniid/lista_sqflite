import 'package:flutter/material.dart';
import 'package:lista_sqflite/providers/database.dart';
import 'package:lista_sqflite/task_page.dart';
import 'package:lista_sqflite/models/task.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DB database = DB();
  late List<Task?> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await database.getTasks();
    setState(() {}); // Atualiza a interface após carregar as tarefas
  }

  void _onTaskSaved() {
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskPage(
                database: database,
                onTaskSaved: _loadTasks,
              )
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: _buildTaskList(),
    );
  }
    Widget _buildTaskList() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task? task = tasks[index];

        return GestureDetector(
          onTap: () {
            // Adicione aqui a navegação para a página de detalhes da tarefa
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.name ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(task?.description ?? ''),  
              ],
            ),
          ),
        );
      },
    );
  }
}