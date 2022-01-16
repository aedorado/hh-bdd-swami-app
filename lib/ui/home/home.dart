import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/more/more.dart';
import 'package:hh_bbds_app/ui/calendar/calendar.dart';
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
      isFavoritesLibrary: true,
    ),
    Calendar(),
    MoreScreen(),
    // AlertScreen(),
  ];

  var _homeSreenAppBarTitles = ['BDD Swami App', 'Favorites', 'Calendar', 'About'];
  // var _homeSreenAppBarTitles = ['BDD Swami App', 'Favorites', 'Mindfulness', 'Alerts'];

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

  _bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0, -2.0),
            color: Color(0x44BDBDBD),
            blurRadius: 8,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline_rounded), label: "About"),
          // BottomNavigationBarItem(icon: Icon(Icons.face_outlined), label: "Mindfulness"),
          // BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "Alerts")
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 240.0,
          floating: false,
          pinned: false,
          snap: false,
          actionsIconTheme: IconThemeData(opacity: 0.0),
          flexibleSpace: CarouselList(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return LibraryHome(isFavoritesLibrary: false);
            },
            childCount: 1, // this.snapshot.data!.size,
          ),
        ),
      ],
    );
  }
}
