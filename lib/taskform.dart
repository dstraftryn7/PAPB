import 'package:flutter/material.dart';

class TaskFormDialog extends StatefulWidget {
  const TaskFormDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskFormDialogState createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              labelText: 'Task Name',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String newTaskName = _taskController.text;

              if (newTaskName.isNotEmpty) {
                Navigator.of(context).pop(newTaskName);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Task name cannot be empty!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
