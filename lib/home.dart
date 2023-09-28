import 'package:flutter/material.dart';
import 'alltask.dart';
import 'scheduled.dart';
import 'task.dart';
import 'today.dart';

void main() {
  runApp(const UTaskApp());
}

class UTaskApp extends StatelessWidget {
  const UTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'U-TASK',
      home: UTaskHomePage(),
    );
  }
}

class UTaskHomePage extends StatefulWidget {
  const UTaskHomePage({super.key});

  @override
  _UTaskHomePageState createState() => _UTaskHomePageState();
}

class _UTaskHomePageState extends State<UTaskHomePage> {
  List<String> boards = [];

  void _addBoard(String board) {
    setState(() {
      boards.add(board);
    });
  }

  void _removeBoard(int index) async {
    bool shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Still want to delete this board?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        boards.removeAt(index);
      });
    }
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    bool logoutConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm LogOut'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (logoutConfirmed == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
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
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(
                  255, 0, 0, 0),
            ),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ]),
      ),
      backgroundColor: const Color.fromARGB(255, 242, 238, 243),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  TodayPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(height: 4),
                            Text('Today'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(
                        '1',
                        style: TextStyle(fontSize: 15), // Ubah ukuran font menjadi 18 (sesuaikan dengan yang Anda inginkan)
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: _navigateToScheduledPage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.timer),
                            SizedBox(height: 4),
                            Text('Scheduled'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(
                        '2',
                        style: TextStyle(fontSize: 15), // Ubah ukuran font menjadi 18 (sesuaikan dengan yang Anda inginkan)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AllTasksPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 0.83,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.all_inbox),
                        SizedBox(height: 4),
                        Text('All Task'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '3',
                    style: TextStyle(fontSize: 15), // Ubah ukuran font menjadi 18 (sesuaikan dengan yang Anda inginkan)
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Board',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) {
                return _buildBoardContainer(boards[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String board = await showDialog(
            context: context,
            builder: (BuildContext context) {
              String newBoard = '';
              return AlertDialog(
                title: const Text('Add Board'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        newBoard = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Board Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (newBoard.isNotEmpty) {
                              Navigator.pop(context, newBoard);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a board name.'),
                                ),
                              );
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );

          // ignore: unnecessary_null_comparison
          if (board != null) {
            _addBoard(board);
          }
        },
        backgroundColor: const Color.fromARGB(255, 202, 172, 205),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBoardContainer(String boardTitle, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskPage(boardTitle: boardTitle),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.83,
        height: 70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.list,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Text(
              boardTitle,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                _editBoard(index);
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                _removeBoard(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editBoard(int index) async {
    String editedBoard = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedName = boards[index];
        return AlertDialog(
          title: const Text('Edit Board'),
          content: TextField(
            autofocus: true,
            controller: TextEditingController(text: editedName),
            onChanged: (value) {
              editedName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, editedName);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    // ignore: unnecessary_null_comparison
    if (editedBoard != null) {
      setState(() {
        boards[index] = editedBoard;
      });
    }
  }

  void _navigateToScheduledPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScheduledPage(),
      ),
    );
  }
}
