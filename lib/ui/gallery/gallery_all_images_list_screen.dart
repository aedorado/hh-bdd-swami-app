import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_constants.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_view_image.dart';
import 'package:hh_bbds_app/utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // TODO date must be stored as date and not as string
        stream: FirebaseFirestore.instance.collection(this.imagesCollectionName).orderBy("date").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var numItems = snapshot.data!.size;
            var imagesList = _getImagesListFromSnapshot(snapshot.data!.docs);
            return DraggableScrollbar.semicircle(
              labelTextBuilder: (offset) {
                final int currentItem = _semicircleController.hasClients
                    ? (_semicircleController.offset / _semicircleController.position.maxScrollExtent * numItems).floor()
                    : 0;
                if (currentItem < numItems) {
                  return Text(
                    DateToLabel('${snapshot.data!.docs[currentItem]['date']}'),
                    style: TextStyle(fontSize: 12),
                  );
                } else {
                  return Text(
                    DateToLabel('${snapshot.data!.docs[numItems - 1]['date']}'),
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
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Hero(
                      tag: imageToDisplay.displayURL,
                      child: Container(
                          child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImageScreen(imagesList: imagesList, index: index)));
                        },
                        child: CachedNetworkImage(
                            imageUrl: imageToDisplay.thumbnailURL,
                            imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error)),
                      )),
                    ),
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

  List<GalleryImage> _getImagesListFromSnapshot(List<QueryDocumentSnapshot<Object?>> docs) {
    return docs.map((doc) => GalleryImage.fromFireBaseSnapshotDoc(doc)).toList();
  }
}
