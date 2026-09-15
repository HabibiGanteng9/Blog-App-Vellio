import 'package:flutter/material.dart';

class Proofile extends StatefulWidget {
  const Proofile({super.key});

  @override
  State<Proofile> createState() => _ProofileState();
}

class _ProofileState extends State<Proofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Profile'),
    );
  }
}