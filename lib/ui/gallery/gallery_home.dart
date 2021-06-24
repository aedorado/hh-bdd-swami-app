import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_albums.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_by_colors.dart';

class GalleryHome extends StatefulWidget {
  @override
  _GalleryHomeState createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  final _animationDuration = 250;
  int selectedSuggestion = 0;

  final List galleryScreenSuggestions = ['YEAR', 'ALBUMS', 'COLORS', 'VIDEOS'];
  final List audioListScreenFutures = [
    FirebaseFirestore.instance.collection("audios").snapshots(),
    FirebaseFirestore.instance.collection("series").snapshots(),
    FirebaseFirestore.instance.collection("seminars").snapshots(),
    FirebaseFirestore.instance.collection("audios").snapshots(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFBDBDBD),
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
                                return _audioListSuggestionBox(
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
              child: PageView.builder(
                itemCount: galleryScreenSuggestions.length,
                itemBuilder: (context, index) {
                  if (index == 1) {
                    return GalleryAlbums();
                  } else if (index == 2) {
                    return GalleryByColors();
                  }
                  return Text('${index}');
                },
                controller: _pageController,
                onPageChanged: (pageNumber) {
                  setState(() {
                    this.selectedSuggestion = pageNumber;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _audioListSuggestionBox(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          this.selectedSuggestion = index;
          this._pageController.animateToPage(index,
              duration: Duration(milliseconds: this._animationDuration),
              curve: Curves.easeIn);
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
        child: AnimatedContainer(
          duration: Duration(milliseconds: this._animationDuration),
          curve: Curves.easeIn,
          decoration: new BoxDecoration(
            color: this.selectedSuggestion == index
                ? Color(0xFF0077C2)
                : Color(0xFFBDBDBD),
            borderRadius: new BorderRadius.all(Radius.elliptical(80, 100)),
          ),
          height: 36,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ScrollController _semicircleController = ScrollController();
// DraggableScrollbar.semicircle(
//         labelTextBuilder: (offset) {
//           final int currentItem = _semicircleController.hasClients
//               ? (_semicircleController.offset /
//                       _semicircleController.position.maxScrollExtent *
//                       numItems)
//                   .floor()
//               : 0;
//
//           return Text("$currentItem");
//         },
//         labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
//         controller: _semicircleController,
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 5,
//           ),
//           controller: _semicircleController,
//           padding: EdgeInsets.zero,
//           itemCount: numItems,
//           itemBuilder: (context, index) {
//             return Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.all(2.0),
//               color: Colors.grey[300],
//             );
//           },
//         ),
//       )
