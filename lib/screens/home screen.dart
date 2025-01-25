import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled48/screens/task%20form%20screen.dart';
import '../model/task model.dart';
import '../provider/task provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: taskProvider.fetchTasks,
          ),
        ],
      ),
      body: FutureBuilder(
        future: taskProvider.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = taskProvider.tasks;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Dismissible(
                key: Key(task.id.toString()),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    taskProvider.updateTask(
                      TaskModel(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        priority: task.priority,
                        isCompleted: true,
                      ),
                    );
                  } else {
                    taskProvider.deleteTask(task.id!);
                  }
                },
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Text(task.priority),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskFormScreen(task: task),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TaskFormScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
