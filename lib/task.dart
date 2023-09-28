import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Definisikan class Task
class Task {
  final String title;
  final String notes;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  bool completed;
  late DateTime combinedDateTime;

  Task({
    required this.title,
    required this.notes,
    this.selectedDate,
    this.selectedTime,
    this.completed = false,
  }) {
    if (selectedDate != null && selectedTime != null) {
      combinedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    } else if (selectedDate != null) {
      combinedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
      );
    } else {
      combinedDateTime = DateTime.now();
    }
  }
}

class TaskPage extends StatefulWidget {
  final String boardTitle;

  const TaskPage({Key? key, required this.boardTitle}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> tasks = [];

  Future<Task?> _showEditTaskDialog(Task task) async {
    final editedTask = await showDialog<Task>(
      context: context,
      builder: (BuildContext context) {
        return EditTaskDialog(task: task);
      },
    );

    if (editedTask != null) {
      setState(() {
        // ignore: unnecessary_null_comparison
        if (task == null) {
          tasks.add(editedTask);
        } else {
          tasks[tasks.indexOf(task)] = editedTask;
        }
        tasks.sort((a, b) => a.combinedDateTime.compareTo(b.combinedDateTime));
      });
    }

    return editedTask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 238, 243),
        elevation: 0,
        title: Row(children: [
          Image.asset(
            'assets/logo.png',
            width: 35,
            height: 35,
          ),
          const SizedBox(width: 8),
          const Text(
            'U-TASK',
            style: TextStyle(
              fontSize: 27,
              color: Color.fromARGB(255, 202, 172, 205),
            ),
          )
        ]),
      ),
      backgroundColor: const Color.fromARGB(255, 242, 238, 243),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Board: ${widget.boardTitle}',
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(
            thickness: 2.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                String dateText = '';
                if (task.selectedDate != null) {
                  if (isSameDay(task.selectedDate!, DateTime.now())) {
                    dateText = 'Hari Ini';
                  } else {
                    dateText = DateFormat.yMMMd().format(task.selectedDate!);
                  }
                }
                return Dismissible(
                  key: Key(task.title),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      bool? deleteConfirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Task'),
                            content: const Text(
                                'Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (deleteConfirmed == true) {
                        setState(() {
                          tasks.removeAt(index);
                        });
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Deleted Successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } else if (direction == DismissDirection.startToEnd) {
                      final editedTask = await _showEditTaskDialog(
                          task);
                      if (editedTask != null) {
                        setState(() {
                          tasks[index] = editedTask;
                        });
                      }
                    }
                  },
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration:
                            task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.notes,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        Text(
                          dateText,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '${task.selectedTime == null ? '' : task.selectedTime!.format(context)}',
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                    value: task.completed,
                    onChanged: (isChecked) {
                      setState(() {
                        task.completed = isChecked!;
                        if (task.completed) {
                          tasks.removeAt(index);
                          tasks.add(task);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => TaskFormDialog(
                        onTaskAdded: (newTask) {
                          setState(() {
                            tasks.add(newTask);
                          });
                        },
                      ),
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 202, 172, 205),
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void initState() {
    super.initState();
    tasks.sort((a, b) => a.combinedDateTime.compareTo(b.combinedDateTime));
  }
}

class TaskFormDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;

  const TaskFormDialog({Key? key, required this.onTaskAdded}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskFormDialogState createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  String title = '';
  String notes = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isTodaySelected = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  notes = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isTodaySelected,
                  onChanged: (value) {
                    setState(() {
                      isTodaySelected = value!;
                      if (isTodaySelected) {
                        selectedDate =
                            DateTime.now();
                      }
                    });
                  },
                ),
                const Text('Hari Ini'),
              ],
            ),
            Row(
              children: [
                Text(
                  'Date: ${selectedDate == null ? 'not set' : DateFormat.yMMMd().format(selectedDate!)}',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Time: ${selectedTime == null ? 'not set' : selectedTime!.format(context)}',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (title.isNotEmpty) {
              final newTask = Task(
                title: title,
                notes: notes,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
              );
              widget.onTaskAdded(newTask);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('field cannot be empty!'),
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late String title;
  late String notes;
  late DateTime? selectedDate;
  late TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    title = widget.task.title;
    notes = widget.task.notes;
    selectedDate = widget.task.selectedDate;
    selectedTime = widget.task.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Edit Task'),
      contentPadding: const EdgeInsets.all(16.0),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              // controller: TextEditingController(text: title),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  notes = value;
                });
              },
              // controller: TextEditingController(text: notes),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Date: ${selectedDate == null ? 'not set' : DateFormat.yMMMd().format(selectedDate!)}',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Time: ${selectedTime == null ? 'not set' : selectedTime!.format(context)}',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                final editedTask = Task(
                  title: title,
                  notes: notes,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  completed: widget.task.completed,
                );
                Navigator.of(context)
                    .pop(editedTask);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
