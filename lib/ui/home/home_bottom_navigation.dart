import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: "Favorites"),
        BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined), label: "Mindfulness"),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined), label: "Alerts"),
        BottomNavigationBarItem(
            icon: Icon(Icons.search), label: "Explore")
      ],
      onTap: (int index) => debugPrint("Tapped item : $index"),
    );
  }
}
