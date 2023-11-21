import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utask/constant.dart';
import 'package:utask/home.dart';

class BoardController {
  // Static addBoard
  static Future<void> addBoard(
      {String? nama,
      required BuildContext context,
      required int id_user}) async {
    final dio = Dio();
    try {
      SharedPreferences boardData = await SharedPreferences.getInstance();
      final response = await dio.post('$baseURL/boards',
          data: json.encode({
            "nama": nama,
            "user_id": id_user,
          }));

      if (response.statusCode == 200) {
        boardData.setString('board_data', json.encode(response.data["board"]));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Board Successfully Added!'),
            duration: Duration(seconds: 2),
          ),
        );
        print("sukses");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const UTaskHomePage()), // Replace HomeScreen() with the appropriate home page class
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error Add Board!'),
            duration: Duration(seconds: 2),
          ),
        );
        print("gagal");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('System Error'),
          duration: Duration(seconds: 2),
        ),
      );
      print("gagal total");
    }
  }
  // End - Static addBoard

  // Static editBoard
  static editBoard({
    String? id,
    String? nama,
    required BuildContext context,
  }) async {
    await editBoard(id: id, nama: nama, context: context);
    final dio = Dio();
    try {
      final response = await dio.put('$baseURL/boards/$id',
          data: json.encode({
            "nama": nama,
          }));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Board Successfully Edited!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const UTaskHomePage()), // Ganti HomeScreen() dengan kelas halaman home yang sesuai
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error Editing Board!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('System Error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  // End - Static editBoard

  // Static removeBoard
  static Future<void> removeBoard({
    required String id,
    required BuildContext context,
  }) async {
    final dio = Dio();
    try {
      final response = await dio.delete('$baseURL/boards/$id');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Board Successfully Removed!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UTaskHomePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error Removing Board!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('System Error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  // End - Static removeBoard

  // start - add task
  static Future<void> addTask(
      {required String title,
      required String description,
      required String datetime,
      required int boards_id,
      required int user_id,
      required BuildContext context}) async {
    final dio = Dio();
    try {
      final response = await dio.post('$baseURL/tasks',
          data: json.encode({
            "title": title,
            "description": description,
            "status": 0,
            "datetime": datetime,
            "boards_id": boards_id,
            "user_id": user_id,
          }));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Board Successfully Added!'),
            duration: Duration(seconds: 2),
          ),
        );
        print("sukses");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const UTaskHomePage()), // Replace HomeScreen() with the appropriate home page class
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error Add Board!'),
            duration: Duration(seconds: 2),
          ),
        );
        print("gagal");
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('System Error'),
          duration: Duration(seconds: 2),
        ),
      );
      print("gagal total");
      print(e.response);
    }
  }
  // end - add task

  static list({int? id}) async {
    var taskData = await SharedPreferences.getInstance();
    final dio = Dio();

    try {
      final response = await dio.get('$baseURL/api/tasks',
          data: json.encode({
            "user_id": id,
          }));
      if (response.statusCode == 200) {
        taskData.setString('task', json.encode(response.data['task']));
      } else {
        print("fail");
      }
    } catch (e) {
      print("kesalahan server $e");
    }
  }
// End-Static listBoard
}
