import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryHome extends StatefulWidget {
  @override
  _GalleryHomeState createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> {
  int numItems = 300;
  ScrollController _semicircleController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: DraggableScrollbar.semicircle(
        labelTextBuilder: (offset) {
          final int currentItem = _semicircleController.hasClients
              ? (_semicircleController.offset /
                      _semicircleController.position.maxScrollExtent *
                      numItems)
                  .floor()
              : 0;

          return Text("$currentItem");
        },
        labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
        controller: _semicircleController,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          controller: _semicircleController,
          padding: EdgeInsets.zero,
          itemCount: numItems,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              color: Colors.grey[300],
            );
          },
        ),
      ),

      // CustomScrollView(
      //   primary: false,
      //   slivers: <Widget>[
      //     SliverGrid(
      //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //         maxCrossAxisExtent: 200.0,
      //         mainAxisSpacing: 10.0,
      //         crossAxisSpacing: 10.0,
      //         childAspectRatio: 4.0,
      //       ),
      //       delegate: SliverChildBuilderDelegate(
      //             (BuildContext context, int index) {
      //           return Container(
      //             alignment: Alignment.center,
      //             color: Colors.teal[100 * (index % 9)],
      //             child: Text('grid item $index'),
      //           );
      //         },
      //         childCount: 200,
      //       ),
      //     ),
      //     // SliverPadding(
      //     //   padding: const EdgeInsets.all(20),
      //     //   sliver: SliverGrid.count(
      //     //     crossAxisSpacing: 10,
      //     //     mainAxisSpacing: 10,
      //     //     crossAxisCount: 2,
      //     //     children: <Widget>[
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text("He'd have you all unravel at the"),
      //     //         color: Colors.green[100],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Heed not the rabble'),
      //     //         color: Colors.green[200],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Sound of screams but the'),
      //     //         color: Colors.green[300],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Who scream'),
      //     //         color: Colors.green[400],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Revolution is coming...'),
      //     //         color: Colors.green[500],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Revolution, they...'),
      //     //         color: Colors.green[600],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Who scream'),
      //     //         color: Colors.green[400],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Revolution is coming...'),
      //     //         color: Colors.green[500],
      //     //       ),
      //     //       Container(
      //     //         padding: const EdgeInsets.all(8),
      //     //         child: const Text('Revolution, they...'),
      //     //         color: Colors.green[600],
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}
