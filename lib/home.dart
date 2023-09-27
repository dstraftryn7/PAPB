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
  // ignore: library_private_types_in_public_api
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
          title: Text('Confirm LogOut'),
          content: Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Batal logout
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Konfirmasi logout
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (logoutConfirmed == true) {
      // Navigasi ke halaman login di sini
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 242, 238, 243),
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
              color: const Color.fromARGB(255, 202, 172, 205),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.exit_to_app, // Ikon logout
              color: const Color.fromARGB(
                  255, 0, 0, 0), // Warna ikon sesuai kebutuhan
            ),
            onPressed: () {
              _showLogoutConfirmation(context); // Tampilkan konfirmasi logout
            },
          ),
        ]),
      ),
      backgroundColor: Color.fromARGB(255, 242, 238, 243),
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
                      builder: (context) => const TodayPage(),
                    ),
                  );
                },
                child: _buildTaskCategory('Today', Icons.calendar_month),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: _navigateToScheduledPage,
                child: _buildTaskCategory('Scheduled', Icons.timer),
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
              width: MediaQuery.of(context).size.width * 0.83,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.all_inbox,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.83,
              child: ListView.builder(
                itemCount: boards.length,
                itemBuilder: (context, index) {
                  return _buildBoardContainer(boards[index], index);
                },
              ),
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

  Widget _buildTaskCategory(String title, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
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
