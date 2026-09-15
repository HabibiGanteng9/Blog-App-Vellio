import 'package:flutter/material.dart';
import 'package:latihan_rpl_2/addpost.dart';
import 'package:latihan_rpl_2/editpost.dart';
import 'package:latihan_rpl_2/homepage.dart';
import 'package:latihan_rpl_2/loginPage.dart';
import 'package:latihan_rpl_2/registPage.dart';
import 'package:latihan_rpl_2/setting.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

void main() {
  runApp(const MyApplication());
}

class MyApplication extends StatefulWidget {
  const MyApplication({super.key});

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Latihan RPL 2",
      home: const Loginpage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int userId;
  final String username;
  final String email;

  const MainPage({
    super.key,
    required this.userId,
    required this.username,
    required this.email,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<HomepageState> homepageKey = GlobalKey<HomepageState>();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: Homepage(
            key: homepageKey,
            userId: widget.userId,
          ),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),

        PersistentTabConfig(
          screen: AddPostPage(
            userId: widget.userId,
            onPostAdded: () {
              setState(() {
                homepageKey.currentState?.getPosts();
              });
            },
          ),
          item: ItemConfig(
            icon: const Icon(Icons.post_add),
            title: "Post",
          ),
        ),

        PersistentTabConfig(
          screen: SettingsScreen(
            username: widget.username,
            email: widget.email,
          ),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
          ),
        ),
      ],

      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}