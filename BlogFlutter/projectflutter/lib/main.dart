import 'package:flutter/material.dart';
import 'package:projectflutter/page/create.dart';
import 'package:projectflutter/page/homepage.dart';
import 'package:projectflutter/page/loginpage.dart';
import 'package:projectflutter/page/notif.dart';
import 'package:projectflutter/page/profile.dart';
import 'package:projectflutter/page/registpage.dart';
import 'package:projectflutter/page/search.dart';

void main () {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        "/login": (context) => Loginpage(),
        "/register": (context) => Registpage(),
        "/home": (context) => HomePage2(),
        "/search": (context) => Search(),
        "/create": (context) => Create(),
        "/notif": (context) => Notif(),
        "/profile": (context) => Proofile(),
      },
    );
  }
}