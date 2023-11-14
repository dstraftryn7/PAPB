import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:utask/constant.dart';
import 'package:utask/home.dart';

class BoardController {
  // Static addBoard
  static addBoard({String? nama, required BuildContext context}) async {
    final dio = Dio();
    try {
      final response = await dio.post('$baseURL/boards',
          data: json.encode({
            "nama": nama,
            "user_id": 1,
          }));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Board Successfully Added!'),
            duration: Duration(seconds: 2),
          ),
        );
        print("sukses");
        // Navigator.of(context).pushNamed('');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const UTaskHomePage()), // Ganti HomeScreen() dengan kelas halaman home yang sesuai
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
  static removeBoard({
    required String id,
    required int index,
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

// End-Static listBoard
}
