import 'package:flutter/material.dart';
class TaskFormDialog extends StatefulWidget {
  const TaskFormDialog({super.key});

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
              // Simpan tugas ke dalam database atau penyimpanan lainnya
              String newTaskName = _taskController.text;
              // Lakukan sesuatu dengan tugas yang baru ditambahkan
              // Misalnya, simpan ke dalam database atau daftar tugas lainnya
              // Kemudian tutup dialog formulir
              Navigator.of(context).pop(newTaskName);
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
