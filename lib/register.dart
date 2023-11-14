import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utask/models/api_response.dart';
import 'package:utask/models/user.dart';
import 'package:utask/services/user_service.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;
  bool _showPassword = false;

  void _registerUser() async {
    ApiResponse response =
        await register(txtName.text, txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const UTaskHomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 238, 243),
      body: Form(
        key: formkey,
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: txtName,
                validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 68, 56, 80)),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) =>
                    val!.isEmpty ? 'Invalid Email Address' : null,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 68, 56, 80)),
              ),
              TextFormField(
                controller: txtPassword,
                obscureText: !_showPassword,
                validator: (val) => val!.isEmpty ? 'Required Password' : null,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(
                          !_showPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: const Color.fromARGB(255, 68, 56, 80),
                        ))),
                style: const TextStyle(color: Color.fromARGB(255, 68, 56, 80)),
              ),
              const SizedBox(height: 6),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            _registerUser();
                          });
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? Login here',
                    style: TextStyle(
                      color: Color.fromARGB(255, 68, 56, 80),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
