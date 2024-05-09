import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final String title;

  const LoginPage({Key? key, required this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(


            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                   TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                   TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text, password: passwordController.text)
                          .then((value) {
                        if (value.user != null) {
                          print("Successfully logged in");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const HomePage(title: 'HomePage'),
                            ),
                          );
                        }
                      }).catchError((error) {
                        print("Failed to login");
                        print(error.toString());
                      });
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                     FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text, password:passwordController.text)
                     .then((value) {
                       print("Succesfully Signed Up the user");
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) =>
                           const HomePage(title: 'HomePage'),
                         ),
                       );
                     }).catchError((error) {
                       print("Failed to Sign Up the user");
                       print(error.toString());
                     });


                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
