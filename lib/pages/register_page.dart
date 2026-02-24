import 'package:chatly/auth/auth_service.dart';
import 'package:chatly/components/my_button.dart';
import 'package:chatly/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onLoginTap});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final VoidCallback onLoginTap;

  // register
  void register(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
      return;
    }

    final authService = AuthService();
    try {
      await authService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

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
              'Let\'s create an account for you!',
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

            SizedBox(height: 10),

            // confirm password input
            MyTextField(
              hintText: 'Confirm Password',
              isPassword: true,
              controller: confirmPasswordController,
            ),

            SizedBox(height: 25),

            // register button
            MyButton(text: 'Register', onTap: () => register(context)),

            SizedBox(height: 25),

            // login now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onLoginTap,
                  child: Text(
                    'Login now!',
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
