import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/network/remote_config.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_constants.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_view_image.dart';

class GalleryByColors extends StatelessWidget {
  late GalleryOperateMode galleryOperateMode;
  late List sectionList;
  late String collectionName;
  late String columToCompare;

  GalleryByColors({required this.galleryOperateMode}) {
    switch (galleryOperateMode) {
      case GalleryOperateMode.OPERATE_MODE_RSS:
        this.sectionList = RemoteConfigService.getSsrssImagesColorsList() ?? [];
        this.collectionName = "ssrss_images";
        this.columToCompare = "color";
        break;
      case GalleryOperateMode.OPERATE_MODE_MHR:
        this.sectionList = RemoteConfigService.getMaharajaImagesPlacesList() ?? [];
        this.collectionName = "maharaja_images";
        this.columToCompare = "location";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: this.sectionList.length,
          itemBuilder: (context, int index) {
            String sectionName = this.sectionList[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('$sectionName'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImagesByColorScreen(
                                  collectionName: this.collectionName,
                                  galleryOperateMode: this.galleryOperateMode,
                                  columnToCompare: this.columToCompare,
                                  valueToCompare: sectionName,
                                )));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection(this.collectionName).where(this.columToCompare, isEqualTo: sectionName).limit(3).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: 160,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.size,
                                  itemBuilder: (context, index) {
                                    GalleryImage imageToDisplay = GalleryImage.fromFireBaseSnapshotDoc(snapshot.data!.docs[index]);
                                    return GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageScreen(imageToDisplay)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                            width: 160,
                                            child: Hero(
                                              tag: imageToDisplay.displayURL,
                                              child: Container(
                                                child: CachedNetworkImage(
                                                  imageUrl: imageToDisplay.thumbnailURL,
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    decoration: BoxDecoration(
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
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    })
              ],
            );
          }),
    );
  }
}

class ImagesByColorScreen extends StatelessWidget {
  late String collectionName;
  late String columnToCompare;
  late String valueToCompare;
  late GalleryOperateMode galleryOperateMode;

  ImagesByColorScreen({Key? key, required this.galleryOperateMode, required this.collectionName, required this.columnToCompare, required this.valueToCompare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(this.collectionName).where(this.columnToCompare, isEqualTo: this.valueToCompare).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return OpenAlbumSliverList(snapshot);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(child: Container(height: 24, width: 24, child: CircularProgressIndicator()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenAlbumSliverList extends StatelessWidget {
  late AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  OpenAlbumSliverList(snapshot) {
    this.snapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              if (snapshot.hasData) {
                GalleryImage imageToDisplay = GalleryImage.fromFireBaseSnapshotDoc(snapshot.data!.docs[index]);
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Hero(
                    tag: imageToDisplay.displayURL,
                    child: Container(
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imageToDisplay.thumbnailURL), fit: BoxFit.cover)),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageScreen(imageToDisplay)));
                          },
                        )),
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }, childCount: snapshot.data!.size),
          ),
        ],
      ),
    );
  }
}
