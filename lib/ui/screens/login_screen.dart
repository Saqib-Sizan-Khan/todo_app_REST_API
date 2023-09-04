import 'package:flutter/material.dart';
import 'package:todo_app/operations/authentication.dart';

class LoginUI extends StatelessWidget {
  LoginUI({Key? key}) : super(key: key);

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Login Information',
                style: TextStyle(fontSize: 28
                    , fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: usernameController,
                style: TextStyle(fontSize: 22),
                decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.person_add,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: passwordController,
                style: TextStyle(fontSize: 22),
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye,
                    )),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 60,
              width: 110,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    loginUser(usernameController.text, passwordController.text);
                  },
                  child: const Text('Log In',
                      style: TextStyle(fontSize: 22, color: Colors.white))),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Need a new account? Go to ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () {},
                  child: const Text('Registration',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
