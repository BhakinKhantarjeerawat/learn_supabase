import 'package:flutter/material.dart';
import 'package:learn_supabase/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUp() async {
    final response = await Supabase.instance.client.auth.signUp(
      email: emailController.text,
      password: passwordController.text,
    );
    debugPrint('Signed up: ${response.user?.email}');
  }

  void signIn() async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    debugPrint('Signed in: ${response.user?.email}');
    Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supabase Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: signIn, child: Text("Sign In")),
                ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
