import 'package:flutter/material.dart';
import 'package:notetaking/main.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  //text editing controller
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create your account',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 25,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Create an account to sync your data accross devices.',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 35),

              //Email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 5),

              //username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 5),

              //password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 5),

              //confirm password textfield
              MyTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 15),

              //Sign in button
              MyButton(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: "TaskBud")));
                },
              ),

              //continue with

              //google button

              const SizedBox(height: 5),
              /*
              Wrap(
                direction: Axis.vertical, //Vertical || Horizontal
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        'By creating an account you agree to our ',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Terms of Service'),
                      ),
                      Text(
                        'and',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Privacy Policy.'),
                      ),
                    ],
                  )
                ],
              ), */

              //not a member, register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'By creating an account you agree to our ',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Terms of Service'),
                  ),
                  Text(
                    'and',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Privacy Policy.'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//design for username and password textfield
class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          fillColor: Colors.grey.shade300,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Function()? onTap;
  const MyButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
