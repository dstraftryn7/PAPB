import 'package:flutter/material.dart';

class ScheduledPage extends StatefulWidget {
  const ScheduledPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduledPageState createState() => _ScheduledPageState();
}

class _ScheduledPageState extends State<ScheduledPage> {
  List<bool> taskCompletedStatusList = [false, false];

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
          const Padding(
            padding: EdgeInsets.only(top: 12.0, left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Scheduled Tasks',
                style: TextStyle(
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Checkbox(
                      value: taskCompletedStatusList[0],
                      onChanged: (bool? value) {
                        setState(() {
                          taskCompletedStatusList[0] = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngajar Ngaji',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: taskCompletedStatusList[0]
                            ? FontWeight.bold
                            : FontWeight.bold,
                        decoration: taskCompletedStatusList[0]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      'TPA AL-IKHLAS',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: taskCompletedStatusList[0]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      'Oct 1, 2023',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: taskCompletedStatusList[0]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      '16:00',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: taskCompletedStatusList[0]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Checkbox(
                      value: taskCompletedStatusList[1],
                      onChanged: (bool? value) {
                        setState(() {
                          taskCompletedStatusList[1] = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IPA',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: taskCompletedStatusList[1]
                            ? FontWeight.bold
                            : FontWeight.bold,
                        decoration: taskCompletedStatusList[1]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      'Tugas Biologi',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: taskCompletedStatusList[1]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      'Oct 3, 2023',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: taskCompletedStatusList[1]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      '18:00',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: taskCompletedStatusList[1]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
