import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/models/podo/album.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_all_images_list_screen.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_constants.dart';

class GalleryAlbums extends StatelessWidget {
  GalleryOperateMode galleryOperateMode;
  late String albumCollectionName;

  GalleryAlbums({required this.galleryOperateMode}) {
    switch (this.galleryOperateMode) {
      case GalleryOperateMode.OPERATE_MODE_RSS:
        this.albumCollectionName = 'ssrss_albums';
        break;
      case GalleryOperateMode.OPERATE_MODE_MHR:
        this.albumCollectionName = 'maharaja_albums';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(this.albumCollectionName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Album album = Album.fromFirebaseAlbumSnapshot(snapshot.data!.docs[index]);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpenAlbum(
                                          galleryOperateMode: this.galleryOperateMode,
                                          album: album,
                                        )));
                          },
                          child: Container(
                            height: 180,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                    child: Container(
                                  child: Hero(
                                    tag: album.id,
                                    child: Image(
                                      image: NetworkImage(album.coverUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: new BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${album.name}',
                                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data!.size, // .length, // this.snapshot.data!.size,
                  ),
                ),
              ],
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class OpenAlbum extends StatelessWidget {
  Album album;
  GalleryOperateMode galleryOperateMode;
  late String imagesCollectionName;

  OpenAlbum({required this.galleryOperateMode, required this.album}) {
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
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: true,
                    pinned: true,
                    snap: false,
                    actionsIconTheme: IconThemeData(opacity: 0.0),
                    flexibleSpace: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: Container(
                          child: Hero(
                            tag: album.id,
                            child: Image(
                              image: NetworkImage(album.coverUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                        Positioned.fill(
                            child: Container(
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
                        )),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.2,
                          left: MediaQuery.of(context).size.width * 0.2,
                          right: MediaQuery.of(context).size.width * 0.2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${album.name}',
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    '${album.description}',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    '${album.totalImages} Images',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _openAlbumSliverList(context, album),
                ],
                // child: StreamBuilder<QuerySnapshot>(
                //   stream: FirebaseFirestore.instance.collection(this.imagesCollectionName).where("album_id", isEqualTo: this.album.id).snapshots(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       return _openAlbumSliverList(context, album, snapshot);
                //     } else if (snapshot.hasError) {
                //       return Text("${snapshot.error}");
                //     }
                //     return Center(child: Container(height: 24, width: 24, child: CircularProgressIndicator()));
                //   },
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openAlbumSliverList(context, Album album) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(this.imagesCollectionName).where("album_id", isEqualTo: this.album.id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                GalleryImage imageToDisplay = GalleryImage.fromFireBaseSnapshotDoc(snapshot.data!.docs[index]);
                return ImageListScreenDisplayContainer(
                  imageToDisplay: imageToDisplay,
                );
              }, childCount: snapshot.data!.size),
            );
          } else if (snapshot.hasError) {
            return SliverToBoxAdapter(child: Text("${snapshot.error}"));
          }
          return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        });
  }
}
