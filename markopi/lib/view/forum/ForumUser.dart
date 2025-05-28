import 'package:flutter/material.dart';

class ForumUser extends StatefulWidget {
  const ForumUser({super.key});

  @override
  State<ForumUser> createState() => _ForumUserState();
}

class _ForumUserState extends State<ForumUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Anda'),
      ),
    );
  }
}