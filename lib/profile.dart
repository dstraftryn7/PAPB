import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';
import 'home.dart';
// ignore: unused_import
import 'models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _currentPasswordController =
  //     TextEditingController();
  // final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 238, 243),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 242, 238, 243),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            // TextFormField(
            //   controller: _currentPasswordController,
            //   obscureText: true,
            //   decoration: const InputDecoration(labelText: 'Current Password'),
            // ),
            // const SizedBox(height: 16),
            // TextFormField(
            //   controller: _newPasswordController,
            //   obscureText: true,
            //   decoration: const InputDecoration(labelText: 'New Password'),
            // ),
            TextFormField(
              controller: _passwordController,
              obscureText:
                  true, // Ini harus diatur ke true untuk menyembunyikan teks
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _loadUserData() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/user'));

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);

        setState(() {
          _nameController.text = userData['name'];
          _emailController.text = userData['email'];
        });
      } else {
        // Handle error
        print('Failed to load user data');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  void _saveChanges() async {
    String newName = _nameController.text;
    String newEmail = _emailController.text;
    // String currentPassword = _currentPasswordController.text;
    // String newPassword = _newPasswordController.text;
    String newPassword = _passwordController.text;

    try {
      final response = await http.put(
        Uri.parse('$baseURL/user'),
        body: {
          'name': newName,
          'email': newEmail,
          // 'current_password': currentPassword,
          // 'new_password': newPassword,
          'password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        _showSaveConfirmation();
      } else {
        // Handle error
        print('Failed to save changes');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  void _showSaveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changes Saved'),
          content: const Text('Your profile changes have been saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UTaskHomePage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    // _currentPasswordController.clear();
    // _newPasswordController.clear();
    _passwordController.clear();
  }
}
