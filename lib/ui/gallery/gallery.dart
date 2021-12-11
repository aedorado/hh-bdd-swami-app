import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/models/podo/image_group.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_view_image.dart';
import 'package:sticky_headers/sticky_headers.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridHeader();
  }
}

class GridHeader extends StatefulWidget {
  @override
  _GridHeaderState createState() => _GridHeaderState();
}

class _GridHeaderState extends State<GridHeader> {
  String imagesGroupsName = 'image_groups';

  PageController _pageController = PageController(
    initialPage: 0,
  );
  final _animationDuration = 200;
  int selectedSuggestion = 0;
  final List galleryScreenSuggestions = [
    'Sri Sri Radha Shyam Sundar',
    'HH Bhakti Dhira Damodar Swami'
  ];
  final List audioListScreenFutures = [
    FirebaseFirestore.instance
        .collection('image_groups')
        .where('is_rss', isEqualTo: true)
        .snapshots(),
    FirebaseFirestore.instance
        .collection('image_groups')
        .where('is_rss', isEqualTo: false)
        .snapshots(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Darshan"),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF005CB2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: galleryScreenSuggestions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _gallerySuggestionBox(
                                  index, galleryScreenSuggestions[index]);
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                AllAlbumsScreen(audioListScreenFutures[0]),
                AllAlbumsScreen(audioListScreenFutures[1])
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gallerySuggestionBox(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          this.selectedSuggestion = index;
          this._pageController.jumpToPage(index);
          // .animateToPage(index, duration: Duration(milliseconds: this._animationDuration), curve: Curves.easeIn);
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
        child: AnimatedContainer(
          duration: Duration(milliseconds: this._animationDuration),
          curve: Curves.easeIn,
          decoration: new BoxDecoration(
            border: this.selectedSuggestion == index
                ? Border(
                    bottom: BorderSide(width: 2.0, color: Color(0xFFE2C56A)))
                : null,
          ),
          height: 36,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                title,
                style: this.selectedSuggestion == index
                    ? TextStyle(
                        color: Color(0xFFE2C56A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800)
                    : TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<ImageGroup> _getImagesListFromSnapshot(
      List<QueryDocumentSnapshot<Object?>> docs) {
    return docs.map((doc) => ImageGroup.fromFireBaseSnapshotDoc(doc)).toList();
  }
}

class AllAlbumsScreen extends StatelessWidget {
  String imagesGroupsName = 'image_groups';

  late Stream<QuerySnapshot<Map<String, dynamic>>> gallerySnapshot;
  AllAlbumsScreen(Stream<QuerySnapshot<Map<String, dynamic>>> gallerySnapshot) {
    this.gallerySnapshot = gallerySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: gallerySnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.size,
              itemBuilder: (BuildContext context, int index) {
                var doc = snapshot.data!.docs[index];
                ImageGroup ig = ImageGroup.fromFireBaseSnapshotDoc(doc);
                return StickyHeader(
                  header: Container(
                    height: 38.0,
                    color: Colors.white,
                    padding: new EdgeInsets.symmetric(horizontal: 12.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ig.groupName,
                      style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  content: Container(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ig.subgroupsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllImagesScreen(
                                          isRss: ig.isRss,
                                          group: ig.subgroupsList[index],
                                        )));
                          },
                          child: Card(
                            margin: EdgeInsets.all(4.0),
                            color: Colors.purpleAccent,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, top: 6.0, bottom: 2.0),
                              child: Center(
                                  child: Text(
                                ig.subgroupsList[index],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class AllImagesScreen extends StatelessWidget {
  late bool isRss;
  late String group;
  String imagesCollectionName = 'images';

  AllImagesScreen({required this.isRss, required this.group});

  List<GalleryImage> _getImagesListFromSnapshot(
      List<QueryDocumentSnapshot<Object?>> docs) {
    return docs
        .map((doc) => GalleryImage.fromFireBaseSnapshotDoc(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Darshan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          // TODO date must be stored as date and not as string
          stream: FirebaseFirestore.instance
              .collection(this.imagesCollectionName)
              .orderBy("date")
              .where('group', isEqualTo: this.group)
              .where('is_rss', isEqualTo: this.isRss)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var numItems = snapshot.data!.size;
              var imagesList = _getImagesListFromSnapshot(snapshot.data!.docs);
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                padding: EdgeInsets.zero,
                itemCount: numItems,
                itemBuilder: (context, index) {
                  GalleryImage imageToDisplay =
                      GalleryImage.fromFireBaseSnapshotDoc(
                          snapshot.data!.docs[index]);
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
                                  builder: (context) => ViewImageScreen(
                                      imagesList: imagesList, index: index)));
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
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error)),
                      )),
                    ),
                  );
                },
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }
}
