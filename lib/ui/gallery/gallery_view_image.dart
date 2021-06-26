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
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 60, name: galleryImage.id);
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
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
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
                                      } else {
                                        favoriteImagesBox.put(this.widget.galleryImage.id, this.widget.galleryImage);
                                      }
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
