import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';
import 'home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 238, 243),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 68, 56, 80)),
        title: const Row(children: [
          SizedBox(width: 8),
          Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 68, 56, 80),
            ),
          )
        ]),
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 120.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
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
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 202, 172, 205)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style:
                              TextStyle(color: Color.fromARGB(255, 68, 56, 80)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadUserData() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/users'), headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token"

      });

      // print('Kode status respons: ${response.statusCode}');
      print('Isi respons: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);

        setState(() {
          _nameController.text = userData['name'];
          _emailController.text = userData['email'];
          // _passwordController.text = userData['password'];
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
    // String newPassword = _passwordController.text;

    try {
      final response = await http.put(
        Uri.parse('$baseURL/api/users'),
        body: {
          'name': newName,
          'email': newEmail,
          // 'password': newPassword,
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
    // _passwordController.clear();
  }
}
