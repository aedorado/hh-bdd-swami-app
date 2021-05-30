import 'package:flutter/material.dart';

class AudioQueueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // backgroundColor: Colors.green,
            title: Text('Have a nice day'),
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.all(15),
                  child: Container(
                    color: Colors.blue[100 * (index % 9 + 1)],
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      "Item $index",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                );
              },
              childCount: 15, // 1000 list items
            ),
          ),
        ],
      )
    );
  }
}

