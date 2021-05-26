import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Hare Krishna'),
          decoration: BoxDecoration(color: Colors.blue, image: DecorationImage(
              image: AssetImage("images/hkmm.jpg"), fit: BoxFit.cover)),
        ),
        ListTile(
          title: Text('Audio Library'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Photo Gallery'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
