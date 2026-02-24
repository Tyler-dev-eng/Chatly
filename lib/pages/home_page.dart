import 'package:chatly/auth/auth_service.dart';
import 'package:chatly/components/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // sign out
  void signOut() async {
    final authService = AuthService();
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      drawer: MyDrawer(),
      body: Center(child: Text('Home Page')),
    );
  }
}
