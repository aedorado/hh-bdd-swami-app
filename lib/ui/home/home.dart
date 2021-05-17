import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/home/home_drawer.dart';

import 'home_carousel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text('Favourites', style: optionStyle,),
    Text('Mindfulness', style: optionStyle,),
    Text('Alerts', style: optionStyle,),
    Text('Explore', style: optionStyle,),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BDD Swami App")),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      drawer: Drawer(
        child: HomeDrawer(),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions_outlined), label: "Mindfulness"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "Alerts"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore")
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselList(),
    );
  }
}

