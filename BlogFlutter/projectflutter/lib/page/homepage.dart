import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int currentIndex = 0;

  final List<Color> colors = [
    Colors.grey,
    Colors.blue,
    Colors.cyan,
    Colors.lightGreen,
    Colors.deepOrange,
  ];

  final List<Widget> pages = [
    const Center(child: Text("Home")),
    const Center(child: Text("Search")),
    const Center(child: Text("Add")),
    const Center(child: Text("Notification")),
    const Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[currentIndex],

      appBar: AppBar(title: const Text("Home Page")),

      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_max_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.grey),
            label: "home",
          ),

          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: Colors.blueAccent),
            label: "search",
          ),

          NavigationDestination(
            icon: Icon(Icons.plus_one),
            selectedIcon: Icon(Icons.plus_one, color: Colors.cyanAccent),
            label: "add",
          ),

          NavigationDestination(
            icon: Icon(Icons.notification_add),
            selectedIcon: Icon(
              Icons.notification_add,
              color: Colors.lightGreen,
            ),
            label: "notif",
          ),

          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(Icons.person, color: Colors.deepOrangeAccent),
            label: "person",
          ),
        ],
      ),
    );
  }
}