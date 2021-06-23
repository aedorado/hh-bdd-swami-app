import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ViewImageScreen extends StatefulWidget {
  GalleryImage galleryImage;

  ViewImageScreen(this.galleryImage);

  @override
  _ViewImageScreenState createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  Box favoriteImagesBox = Hive.box<GalleryImage>(HIVE_BOX_FAVORITE_IMAGES);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: this.widget.galleryImage.displayURL,
                child: CachedNetworkImage(
                  imageUrl: this.widget.galleryImage.displayURL,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                // child: Container(
                //   decoration: BoxDecoration(image:DecorationImage(image: CachedNetworkImage(imageUrl: widget.url), fit: BoxFit.cover)),
                // ),
              ),
            ),
            Container(
              height: 44,
              decoration: BoxDecoration(color: const Color(0xFF42A5F5)),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          child: IconButton(
                              icon: Icon(Icons.download_sharp),
                              onPressed: () {
                                debugPrint('Downloading...');
                              }))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          child: ValueListenableBuilder(
                              valueListenable: favoriteImagesBox.listenable(),
                              builder: (context, Box box, widget) {
                                var isAleadyAddedToFavorites =
                                    box.get(this.widget.galleryImage.id) !=
                                        null;
                                return IconButton(
                                    icon: Icon(
                                      isAleadyAddedToFavorites
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      if (isAleadyAddedToFavorites) {
                                        favoriteImagesBox.delete(
                                            this.widget.galleryImage.id);
                                      } else {
                                        favoriteImagesBox.put(
                                            this.widget.galleryImage.id,
                                            this.widget.galleryImage);
                                      }
                                      // debugPrint('Downloading...');
                                    });
                              })))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
