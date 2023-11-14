import 'package:flutter/material.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  bool isTaskCompleted = false;

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
                'Today Tasks',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 68, 56, 80),
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
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       Column(
          //         children: [
          //           Checkbox(
          //             value: isTaskCompleted,
          //             onChanged: (bool? value) {
          //               setState(() {
          //                 isTaskCompleted = value ?? false;
          //               });
          //             },
          //           ),
          //         ],
          //       ),
          //       const SizedBox(width: 16),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Tugas Math',
          //             style: TextStyle(
          //               fontSize: 15,
          //               fontWeight: isTaskCompleted
          //                   ? FontWeight.normal
          //                   : FontWeight.bold,
          //               decoration: isTaskCompleted
          //                   ? TextDecoration.lineThrough
          //                   : TextDecoration.none,
          //             ),
          //           ),
          //           Text(
          //             'Hal 90',
          //             style: TextStyle(
          //               fontSize: 15,
          //               decoration: isTaskCompleted
          //                   ? TextDecoration.lineThrough
          //                   : TextDecoration.none,
          //             ),
          //           ),
          //           Text(
          //             'Hari ini',
          //             style: TextStyle(
          //               fontSize: 15,
          //               decoration: isTaskCompleted
          //                   ? TextDecoration.lineThrough
          //                   : TextDecoration.none,
          //             ),
          //           ),
          //           Text(
          //             '19:00',
          //             style: TextStyle(
          //               fontSize: 15,
          //               decoration: isTaskCompleted
          //                   ? TextDecoration.lineThrough
          //                   : TextDecoration.none,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
