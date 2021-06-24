import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/ui/gallery/view_image.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteImages extends StatelessWidget {
  final Box favoriteImagesBox =
      Hive.box<GalleryImage>(HIVE_BOX_FAVORITE_IMAGES);

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
                        GalleryImage imageToDisplay =
                            favoriteImagesBox.getAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewImageScreen(imageToDisplay)));
                            },
                            child: Hero(
                              tag: imageToDisplay.displayURL,
                              child: CachedNetworkImage(
                                imageUrl: imageToDisplay.displayURL,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: favoriteImagesBox.length,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
