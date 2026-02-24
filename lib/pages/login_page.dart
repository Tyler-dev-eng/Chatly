import 'package:chatly/auth/auth_service.dart';
import 'package:chatly/components/my_button.dart';
import 'package:chatly/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.onRegisterTap});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login
  void login() async {
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');

    final authService = AuthService();

    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      print(e);
    }
  }

  // tap to go to register page
  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            SizedBox(height: 50),

            // welcome text
            Text(
              'Welcome to Chatly',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            SizedBox(height: 25),

            // email input
            MyTextField(
              hintText: 'Email',
              isPassword: false,
              controller: emailController,
            ),

            SizedBox(height: 10),

            // password input
            MyTextField(
              hintText: 'Password',
              isPassword: true,
              controller: passwordController,
            ),

            SizedBox(height: 25),

            // login button
            MyButton(text: 'Login', onTap: login),

            SizedBox(height: 25),

            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onRegisterTap,
                  child: Text(
                    'Register now!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
