import 'package:flutter/material.dart';
import 'database_helper.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final dbHelper = DatabaseHelper();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  int? selectedId;
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    refreshTasks();
  }

  void refreshTasks() async {
    final data = await dbHelper.getTasks();
    setState(() {
      tasks = data;
    });
  }

  void saveTask() async {
    final title = titleController.text.trim();
    final desc = descController.text.trim();
    if (title.isEmpty) return;

    if (selectedId == null) {
      await dbHelper.insertTask({'title': title, 'description': desc});
    } else {
      await dbHelper.updateTask({
        'id': selectedId,
        'title': title,
        'description': desc,
      });
      selectedId = null;
    }

    titleController.clear();
    descController.clear();
    refreshTasks();
  }

  void editTask(Map<String, dynamic> task) {
    setState(() {
      selectedId = task['id'];
      titleController.text = task['title'];
      descController.text = task['description'] ?? '';
    });
  }

  void deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveTask,
              child: Text(selectedId == null ? 'Add Task' : 'Update Task'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks yet'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task['title']),
                            subtitle: Text(task['description'] ?? ''),
                            onTap: () => editTask(task),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTask(task['id']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
