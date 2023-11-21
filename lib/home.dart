import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alltask.dart';
import 'constant.dart';
import 'models/board_api2.dart';
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
  TextEditingController boardController = TextEditingController();

  List<Map<String, dynamic>> boardo = [];
  late int id_user;
  var jsonList;

  void getBoard() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id_user = pref.getInt('userId')!;
    try {
      var response =
          await Dio().get('$baseURL/boards/${pref.getInt('userId')}');
      if (response.statusCode == 200) {
        // setState(() {
        // jsonList = response.data["boards"] as List;
        for (var obj in response.data["boards"]) {
          int id_board = obj["id"];
          String nama = obj["nama"];
          setState(() {
            boardo.add({"id": id_board, "nama": nama});
          });
        }
      }
    } catch (e) {}
  }

  void _removeBoard(int index) async {
    var shouldDelete = await showDialog(
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
              onPressed: () async {
                await BoardController.removeBoard(
                    id: boardo[index]['id'].toString(), context: context);
                boardo = [];
                getBoard();
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
        // boards.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Board deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
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
  void initState() {
    super.initState();
    getBoard();
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
              Icons.person,
              color: Color.fromARGB(255, 68, 56, 80),
            ),
            onPressed: () {
              // Fungsi untuk mengarahkan ke halaman profile.dart
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 68, 56, 80),
            ),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ]),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 242, 238, 243),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.calendar_month,
                                color: Color.fromARGB(255, 68, 56, 80)),
                            SizedBox(height: 4),
                            Text('Today',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 68, 56, 80))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 68, 56, 80)),
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
                    color: const Color.fromARGB(255, 242, 238, 243),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.timer,
                                color: Color.fromARGB(255, 68, 56, 80)),
                            SizedBox(height: 4),
                            Text('Scheduled',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 68, 56, 80))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 68, 56, 80)),
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
                color: const Color.fromARGB(255, 242, 238, 243),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.all_inbox,
                            color: Color.fromARGB(255, 68, 56, 80)),
                        SizedBox(height: 4),
                        Text('All Task',
                            style: TextStyle(
                                color: Color.fromARGB(255, 68, 56, 80))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '0',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 68, 56, 80)),
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
                  color: Color.fromARGB(255, 68, 56, 80),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ListView.builder(
                itemCount: boardo.length,
                itemBuilder: (context, index) {
                  return _buildBoardContainer(boardo[index], index);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var board = await showDialog(
            context: context,
            builder: (BuildContext context) {
              String newBoard = '';
              return AlertDialog(
                title: const Text('Add Board',
                    style: TextStyle(color: Color.fromARGB(255, 68, 56, 80))),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      controller: boardController,
                      onChanged: (value) {
                        newBoard = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Board Name',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 68, 56, 80),
                        ),
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
                          onPressed: () async {
                            if (newBoard.isNotEmpty) {
                              await BoardController.addBoard(
                                  context: context,
                                  nama: boardController.text,
                                  id_user: id_user);
                              boardController.clear();
                              boardo = [];
                              getBoard();
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
            // _addBoard(board);
          }
        },
        backgroundColor: const Color.fromARGB(255, 202, 172, 205),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBoardContainer(Map<String, dynamic> boardTitle, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskPage(
                boardTitle: boardTitle['nama'], boardId: boardTitle['id']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.83,
        height: 70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 238, 243),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.list,
              color: Color.fromARGB(255, 68, 56, 80),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                boardTitle['nama'],
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 68, 56, 80),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit,
                  color: Color.fromARGB(255, 68, 56, 80)),
              onPressed: () {
                // print(index);
                _editBoard(index);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete,
                  color: Color.fromARGB(255, 68, 56, 80)),
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
    var editedBoard = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedName = boardo[index]['nama'];
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
              onPressed: () async {
                // Mengirim permintaan ke server Laravel untuk mengedit board
                await editBoardOnServer(boardo[index]['id'], editedName);
                boardo = [];
                getBoard();
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
        // boards[index] = editedBoard;
        // boardo[index]['nama'] = editedBoard;
        // boardo = [];
        // getBoard();
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Board edited successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

// Tambahkan fungsi berikut untuk mengirim permintaan ke server Laravel
  Future<void> editBoardOnServer(int index, String editedName) async {
    try {
      await Dio().put('$baseURL/boards/$index', data: {"nama": editedName});
    } catch (e) {
      print("Failed to edit board on server: $e");
      // Handle error accordingly
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
