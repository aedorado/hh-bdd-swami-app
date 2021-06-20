import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_albums.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteImages extends StatelessWidget {
  Box favoriteImagesBox = Hive.box(HIVE_BOX_FAVORITE_IMAGES);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Images'),
      ),
      body: Container(
        child: ValueListenableBuilder(
            valueListenable: favoriteImagesBox.listenable(),
            builder: (context, Box box, widget) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Hero(
                          tag: favoriteImagesBox.getAt(index),
                          // TODO Add cached Network Image here
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          favoriteImagesBox.getAt(index)),
                                      fit: BoxFit.cover)),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewImageScreen(
                                              index,
                                              favoriteImagesBox.getAt(index))));
                                },
                                child: (index % 4 != 0)
                                    ? Container()
                                    : Container(
                                        child: Center(
                                          child: Container(
                                              child: Icon(
                                            Icons.play_arrow,
                                            size: 40,
                                            color: Colors.white,
                                          )),
                                        ),
                                      ),
                              )),
                        ),
                      );
                    },
                        childCount: favoriteImagesBox
                            .length // .length, // this.snapshot.data!.size,
                        ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
