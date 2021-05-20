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
        new Flexible(flex: 1, child: HomeScreenBottomCard(displayString: "Association", displayImage: "https://i.postimg.cc/3Jc0NCqK/A.jpg")),
        new Flexible(flex: 1, child: HomeScreenBottomCard(displayString: "Books", displayImage: "https://i.postimg.cc/1zxgcRP2/B.jpg")),
        new Flexible(flex: 1, child: HomeScreenBottomCard(displayString: "Chanting", displayImage: "https://i.postimg.cc/RZJ6HJrw/c.jpg")),
      ],
    );
  }

}

class HomeScreenBottomCard extends StatelessWidget {

  final String displayString;
  final String displayImage;
  const HomeScreenBottomCard({Key key, this.displayString, this.displayImage}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(displayImage), fit: BoxFit.cover)
      ),
      child: Column(
        children: [
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
            child: Center(
              child: Text(displayString, style: new TextStyle(fontSize: 18.0),),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}



