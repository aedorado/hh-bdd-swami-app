import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_albums.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_all_images_list_screen.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_by_colors.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_constants.dart';

class GalleryHome extends StatefulWidget {
  late GalleryOperateMode galleryOperateMode;

  GalleryHome({required this.galleryOperateMode});

  @override
  _GalleryHomeState createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  final _animationDuration = 250;
  int selectedSuggestion = 0;

  late List galleryScreenSuggestions = (widget.galleryOperateMode == GalleryOperateMode.OPERATE_MODE_RSS)
      ? ['ALL', 'ALBUMS', 'COLORS']
      : ['ALL', 'ALBUMS', 'PLACES'];

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
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF005CB2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: galleryScreenSuggestions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _gallerySuggestionBox(index, galleryScreenSuggestions[index]);
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
                  if (index == 0) {
                    return AllImagesListScreen(
                      galleryOperateMode: widget.galleryOperateMode,
                    );
                  } else if (index == 1) {
                    return GalleryAlbums(
                      galleryOperateMode: widget.galleryOperateMode,
                    );
                  } else if (index == 2) {
                    return GalleryByColors(
                      galleryOperateMode: widget.galleryOperateMode,
                    );
                  }
                  return Container();
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

  Widget _gallerySuggestionBox(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          this.selectedSuggestion = index;
          this
              ._pageController
              .animateToPage(index, duration: Duration(milliseconds: this._animationDuration), curve: Curves.easeIn);
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
        child: AnimatedContainer(
          duration: Duration(milliseconds: this._animationDuration),
          curve: Curves.easeIn,
          decoration: new BoxDecoration(
              border: this.selectedSuggestion == index
                  ? Border(
                      bottom: BorderSide(width: 2.0, color: Color(0xFFE2C56A)),
                    )
                  : null),
          height: 32,
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
