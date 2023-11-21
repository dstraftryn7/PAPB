import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utask/home.dart';
import 'package:utask/models/api_response.dart';
import 'package:utask/models/user.dart';
import 'package:utask/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;
  bool _showPassword = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
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

    // Show a success Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful!'),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const UTaskHomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Form(
          key: formkey,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill,
                )),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/logo.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: txtEmail,
                          validator: (val) =>
                              val!.isEmpty ? 'Invalid Email Address' : null,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.person),
                          ),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 68, 56, 80)),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: txtPassword,
                          obscureText: !_showPassword,
                          validator: (val) =>
                              val!.isEmpty ? 'Required Password' : null,
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
                                    color:
                                        const Color.fromARGB(255, 68, 56, 80),
                                  ))),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 68, 56, 80)),
                        ),
                        const SizedBox(height: 15),
                        loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                      _loginUser();
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 202, 172, 205)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Don\'t have an account yet? Register here',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
