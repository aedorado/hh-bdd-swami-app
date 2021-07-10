import 'package:flutter/material.dart';

class MindfulnessScreen extends StatelessWidget {
  const MindfulnessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 300.0,
          floating: true,
          pinned: true,
          snap: false,
          actionsIconTheme: IconThemeData(opacity: 0.0),
          flexibleSpace: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Image.network(
                "https://vrindavandarshan.in/upload_images/dailydarshan/2021-06-01-Mycnz.jpg",
                fit: BoxFit.cover,
              )),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(clipBehavior: Clip.none, children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          'Something',
                          style: TextStyle(fontSize: 24),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "Something",
                        // '${this.audioFolder.description}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(child: Text('Coming Soon'));
            },
            childCount: 20, // this.snapshot.data!.size,
          ),
        ),
      ],
    );
  }
}
