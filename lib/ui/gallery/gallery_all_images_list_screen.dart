import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_constants.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_view_image.dart';

class AllImagesListScreen extends StatelessWidget {
  ScrollController _semicircleController = ScrollController();

  late String imagesCollectionName;
  late GalleryOperateMode galleryOperateMode;

  AllImagesListScreen({required this.galleryOperateMode}) {
    switch (this.galleryOperateMode) {
      case GalleryOperateMode.OPERATE_MODE_RSS:
        this.imagesCollectionName = 'ssrss_images';
        break;
      case GalleryOperateMode.OPERATE_MODE_MHR:
        this.imagesCollectionName = 'maharaja_images';
        break;
    }
  }

  _getLabelText(String d) {
    var parts = d.split(' ')[0].split('-');
    String ds = "";
    switch (parts[1]) {
      case "01":
        ds += " Jan";
        break;
      case "02":
        ds += " Feb";
        break;
      case "03":
        ds += " Mar";
        break;
      case "04":
        ds += " Apr";
        break;
      case "05":
        ds += " May";
        break;
      case "06":
        ds += " Jun";
        break;
      case "07":
        ds += " Jul";
        break;
      case "08":
        ds += " Aug";
        break;
      case "09":
        ds += " Sep";
        break;
      case "10":
        ds += " Oct";
        break;
      case "11":
        ds += " Nov";
        break;
      case "12":
        ds += " Dec";
        break;
    }
    ds += " " + parts[0];
    return ds;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // TODO date must be stored as date and not as string
        stream: FirebaseFirestore.instance.collection(this.imagesCollectionName).orderBy("date").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var numItems = snapshot.data!.size;
            return DraggableScrollbar.semicircle(
              labelTextBuilder: (offset) {
                final int currentItem = _semicircleController.hasClients
                    ? (_semicircleController.offset / _semicircleController.position.maxScrollExtent * numItems).floor()
                    : 0;
                if (currentItem < numItems) {
                  return Text(
                    _getLabelText('${snapshot.data!.docs[currentItem]['date']}'),
                    style: TextStyle(fontSize: 12),
                  );
                } else {
                  return Text(
                    _getLabelText('${snapshot.data!.docs[numItems - 1]['date']}'),
                    style: TextStyle(fontSize: 12),
                  );
                }
              },
              labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
              controller: _semicircleController,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                controller: _semicircleController,
                padding: EdgeInsets.zero,
                itemCount: numItems,
                itemBuilder: (context, index) {
                  GalleryImage imageToDisplay = GalleryImage.fromFireBaseSnapshotDoc(snapshot.data!.docs[index]);
                  return ImageListScreenDisplayContainer(
                    imageToDisplay: imageToDisplay,
                  );
                },
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}

class ImageListScreenDisplayContainer extends StatelessWidget {
  late GalleryImage imageToDisplay;
  ImageListScreenDisplayContainer({required this.imageToDisplay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Hero(
        tag: imageToDisplay.displayURL,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(imageToDisplay.thumbnailURL), fit: BoxFit.cover)),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageScreen(imageToDisplay)));
              },
              child: (imageToDisplay.type == "Video")
                  ? Container(
                      child: Center(
                        child: Container(
                            child: Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        )),
                      ),
                    )
                  : Container(),
            )),
      ),
    );
  }
}
