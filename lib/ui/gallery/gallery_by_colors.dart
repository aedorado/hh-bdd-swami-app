import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/ui/gallery/view_image.dart';
import 'package:hh_bbds_app/ui/home/home.dart';

class GalleryByColors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('images_unique_colors')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, int index) {
                      String colorName = snapshot.data!.docs[index]['color'];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('${colorName}'),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImagesByColorScreen(
                                            color: colorName,
                                          )));
                            },
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('images')
                                  .where("color", isEqualTo: colorName)
                                  .limit(3)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: 180,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.size,
                                            itemBuilder: (context, index) {
                                              GalleryImage imageToDisplay = Adapter
                                                  .firebaseAlbumsSnapshotToGalleryImage(
                                                      snapshot
                                                          .data!.docs[index]);
                                              return GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewImageScreen(
                                                                  imageToDisplay)));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Container(
                                                      width: 180,
                                                      child: Hero(
                                                        tag: imageToDisplay
                                                            .displayURL,
                                                        child: Container(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                imageToDisplay
                                                                    .thumbnailURL,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
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
                                return Center(
                                    child: CircularProgressIndicator());
                              })
                        ],
                      );
                    }),
              );
              return Container();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class ImagesByColorScreen extends StatelessWidget {
  final String color;

  const ImagesByColorScreen({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("images")
                    .where("color", isEqualTo: this.color)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return OpenAlbumSliverList(snapshot);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                      child: Container(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator()));
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
  // Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
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
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              if (snapshot.hasData) {
                GalleryImage imageToDisplay =
                    Adapter.firebaseAlbumsSnapshotToGalleryImage(
                        snapshot.data!.docs[index]);
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Hero(
                    tag: imageToDisplay.displayURL,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    NetworkImage(imageToDisplay.thumbnailURL),
                                fit: BoxFit.cover)),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewImageScreen(imageToDisplay)));
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
              }
              return Center(child: CircularProgressIndicator());
            },
                childCount:
                    snapshot.data!.size // .length, // this.snapshot.data!.size,
                ),
          ),
        ],
      ),
    );
  }
}
