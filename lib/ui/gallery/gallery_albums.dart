import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/models/podo/album.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/ui/gallery/view_image.dart';

class GalleryAlbums extends StatefulWidget {
  @override
  _GalleryAlbumsState createState() => _GalleryAlbumsState();
}

class _GalleryAlbumsState extends State<GalleryAlbums> {
  var totalAlbums;

  @override
  void initState() {
    // TODO: implement initState
    initAsync();
    super.initState();
  }

  initAsync() async {
    totalAlbums = await FirebaseFirestore.instance
        .collection('albums')
        .snapshots()
        .length;
    debugPrint(totalAlbums);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("albums").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text(
                      '${this.totalAlbums} Albums  • 16108 Photos •  192 Videos',
                      style: TextStyle(color: Color(0xFF0077C2)),
                    ),
                  )),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Album album = Adapter.firebaseAlbumsSnapshotToAlbum(
                          snapshot.data!.docs[index]);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpenAlbum(album)));
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
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snapshot
                        .data!.size, // .length, // this.snapshot.data!.size,
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

  OpenAlbum(this.album);

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
                    .where("album_id", isEqualTo: this.album.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _openAlbumSliverList(context, album, snapshot);
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

  _openAlbumSliverList(
      context, Album album, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return CustomScrollView(
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
                          '${album.totalImages} Images • ${album.totalVideos} Videos',
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
                              image: NetworkImage(imageToDisplay.thumbnailURL),
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
    );
  }
}

// class OpenAlbumSliverList extends StatelessWidget {
//   // Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
//   late Album album;
//   late AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
//
//   OpenAlbumSliverList(album, snapshot) {
//     this.album = album;
//     this.snapshot = snapshot;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       physics: BouncingScrollPhysics(),
//       slivers: [
//         SliverAppBar(
//           expandedHeight: 250.0,
//           floating: true,
//           pinned: true,
//           snap: false,
//           actionsIconTheme: IconThemeData(opacity: 0.0),
//           flexibleSpace: Stack(
//             children: <Widget>[
//               Positioned.fill(
//                   child: Container(
//                 // decoration: BoxDecoration(
//                 //   image: DecorationImage(image: NetworkImage(album.coverUrl), fit: BoxFit.cover)
//                 // ),
//                 child: Hero(
//                   tag: album.id,
//                   child: Image(
//                     image: NetworkImage(album.coverUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               )),
//               Positioned.fill(
//                   child: Container(
//                 decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
//               )),
//               Positioned(
//                 top: MediaQuery.of(context).size.height * 0.2,
//                 left: MediaQuery.of(context).size.width * 0.2,
//                 right: MediaQuery.of(context).size.width * 0.2,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5.0),
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           '${album.name}',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         ),
//                         Text(
//                           '${album.description}',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                         Text(
//                           '',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                         Text(
//                           '${album.totalImages} Images • ${album.totalVideos} Videos',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         SliverGrid(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//           delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
//             if (snapshot.hasData) {
//               return Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: Hero(
//                   tag: this.snapshot.data!.docs[index]['display_url'],
//                   child: Container(
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: NetworkImage(this
//                                   .snapshot
//                                   .data!
//                                   .docs[index]['thumbnail_url']),
//                               fit: BoxFit.cover)),
//                       child: GestureDetector(
//                         behavior: HitTestBehavior.translucent,
//                         onTap: () {
//                           Navigator.push(
//                               context, MaterialPageRoute(builder: (context) => ViewImageScreen(index, this.snapshot.data!.docs[index]['display_url'])));
//                         },
//                         child: (index % 4 != 0)
//                             ? Container()
//                             : Container(
//                           child: Center(
//                             child: Container(
//                                 child: Icon(
//                                   Icons.play_arrow,
//                                   size: 40,
//                                   color: Colors.white,
//                                 )),
//                           ),
//                         ),
//                       )),
//                 ),
//               );
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//               childCount: this
//                   .snapshot
//                   .data!
//                   .size // .length, // this.snapshot.data!.size,
//               ),
//         ),
//       ],
//     );
//   }
// }

