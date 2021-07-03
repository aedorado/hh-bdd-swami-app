import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewImageScreen extends StatefulWidget {
  GalleryImage galleryImage;

  ViewImageScreen(this.galleryImage);

  @override
  _ViewImageScreenState createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  Box favoriteImagesBox = Hive.box<GalleryImage>(HIVE_BOX_FAVORITE_IMAGES);
  bool shouldShowSnackbar = true;

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  _saveImage(GalleryImage galleryImage) async {
    _toastInfo("Downloading Image");
    var response = await Dio().get(galleryImage.downloadURL, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 60, name: galleryImage.id);
    _toastInfo("Image saved to Gallery");
  }

  downloadFile(GalleryImage galleryImage) async {
    await _requestPermission();
    await _saveImage(galleryImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 7,
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
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: const Color(0xFF42A5F5)),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: IconButton(
                                icon: Icon(Icons.download_sharp),
                                onPressed: () {
                                  downloadFile(this.widget.galleryImage);
                                }))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: ValueListenableBuilder(
                                valueListenable: favoriteImagesBox.listenable(),
                                builder: (context, Box box, widget) {
                                  var isAleadyAddedToFavorites = box.get(this.widget.galleryImage.id) != null;
                                  return IconButton(
                                      icon: Icon(
                                        isAleadyAddedToFavorites ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        if (isAleadyAddedToFavorites) {
                                          favoriteImagesBox.delete(this.widget.galleryImage.id);
                                          if (shouldShowSnackbar) {
                                            ScaffoldMessenger.of(context).showSnackBar(FavoritesImagesSnackBar(
                                              favoritesActionPerformed: FAVORITES_ACTION_REMOVE,
                                            ).build(context));
                                            setState(() {
                                              this.shouldShowSnackbar = false;
                                            });
                                            Future.delayed(Duration(seconds: 1), () {
                                              setState(() {
                                                this.shouldShowSnackbar = true;
                                              });
                                            });
                                          }
                                        } else {
                                          favoriteImagesBox.put(this.widget.galleryImage.id, this.widget.galleryImage);
                                          if (shouldShowSnackbar) {
                                            ScaffoldMessenger.of(context).showSnackBar(FavoritesImagesSnackBar(
                                              favoritesActionPerformed: FAVORITES_ACTION_ADD,
                                            ).build(context));
                                            setState(() {
                                              this.shouldShowSnackbar = false;
                                            });
                                            Future.delayed(Duration(seconds: 1), () {
                                              setState(() {
                                                this.shouldShowSnackbar = true;
                                              });
                                            });
                                          }
                                        }
                                      });
                                })))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(
                    children: [
                      _descriptionTextBox('${widget.galleryImage.description}', 20),
                      _descriptionTextBox('${widget.galleryImage.date}', 14),
                      _descriptionTextBox('${widget.galleryImage.location}', 14),
                      _descriptionTextBox('${widget.galleryImage.tags}', 14),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _descriptionTextBox(String s, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        child: Text(
          '$s',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}

class FavoritesImagesSnackBar extends StatelessWidget {
  final String favoritesActionPerformed;
  late final String _snackBarText;

  FavoritesImagesSnackBar({required this.favoritesActionPerformed}) {
    if (this.favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
      _snackBarText = 'Removed from Favorites';
    } else {
      _snackBarText = 'Added to Favorites';
    }
  }

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Text(_snackBarText),
      duration: Duration(milliseconds: 1000),
    );
  }
}
