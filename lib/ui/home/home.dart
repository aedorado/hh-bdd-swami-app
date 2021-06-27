import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/alerts/alert_screen.dart';
import 'package:hh_bbds_app/ui/library/library_home.dart';

import 'home_carousel.dart';

class Home extends StatefulWidget {
  int selectedIndex;

  Home({required this.selectedIndex});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LibraryHome(
      isFavoritesLibrary: false,
    ),
    LibraryHome(
      isFavoritesLibrary: true,
    ),
    AlertScreen(),
  ];

  var _homeSreenAppBarTitles = ['BDD Swami App', 'Library', 'Favorites', 'Alerts'];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_homeSreenAppBarTitles[widget.selectedIndex]),
      ),
      body: _widgetOptions.elementAt(widget.selectedIndex),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Library"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "Alerts")
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          new Expanded(flex: 7, child: CarouselList()),
          new Expanded(flex: 11, child: HomeScreenBottomCards()),
        ],
      ),
    );
  }
}

class HomeScreenBottomCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        new Flexible(flex: 1, child: HomeScreenBottomCard(displayString: "Association", displayImage: "images/A.jpg")),
        new Flexible(flex: 1, child: HomeScreenBottomCard(displayString: "Books", displayImage: "images/B.jpg")),
        new Flexible(flex: 1, child: HomeScreenBottomCard(displayString: "Chanting", displayImage: "images/C.jpg")),
      ],
    );
  }
}

class HomeScreenBottomCard extends StatelessWidget {
  final String displayString;
  final String displayImage;

  const HomeScreenBottomCard({Key? key, required this.displayString, required this.displayImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(displayImage), fit: BoxFit.cover)),
      child: Column(
        children: [
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
            child: Center(
              child: Text(
                displayString,
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
