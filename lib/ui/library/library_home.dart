import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_audios.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_images.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_quotes.dart';
import 'package:hh_bbds_app/ui/gallery/gallery.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_constants.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_home.dart';
import 'package:hh_bbds_app/ui/quotes/quotes_screen.dart';

class LibraryHome extends StatelessWidget {
  bool isFavoritesLibrary = false;

  LibraryHome({required this.isFavoritesLibrary});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 8.0),
        child: this.isFavoritesLibrary
            ? _getFavoritesLibraryContent()
            : _getGeneralibraryContent());
  }

  _sectionHeader(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF444444),
            fontSize: 28.0,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  _getFavoritesLibraryContent() {
    return ListView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          _sectionHeader("Vani"),
          Container(
            height: 200,
            child: Row(
              children: [
                new Flexible(
                    flex: 1,
                    child: LibraryCard(
                        displayImage: "images/A.png", route: FavoriteAudios())),
                // new Flexible(flex: 1, child: LibraryCard(displayString: "Videos", displayImage: "https://i.postimg.cc/1zxgcRP2/B.jpg",)),
              ],
            ),
          ),
          _sectionHeader("Darshan"),
          Container(
            height: 200,
            child: Row(
              children: [
                new Flexible(
                    flex: 1,
                    child: LibraryCard(
                      displayImage: "images/B.png",
                      route: FavoriteImages(),
                    )),
              ],
            ),
          ),
          _sectionHeader("Quotes"),
          Container(
            height: 200,
            child: Row(
              children: [
                new Flexible(
                    flex: 1,
                    child: LibraryCard(
                      displayImage: "images/Q.png",
                      route: FavoriteQuotes(),
                    )),
              ],
            ),
          ),
        ]);
  }

  _getGeneralibraryContent() {
    return Column(children: [
      _sectionHeader("Vani"),
      Container(
        height: 200,
        child: Row(
          children: [
            new Flexible(
                flex: 1,
                child: LibraryCard(
                    displayImage: "images/A.png", route: AudioListScreen())),
            // new Flexible(flex: 1, child: LibraryCard(displayString: "Videos", displayImage: "https://i.postimg.cc/1zxgcRP2/B.jpg",)),
          ],
        ),
      ),
      _sectionHeader("Darshan"),
      Container(
        height: 200,
        child: Row(
          children: [
            new Flexible(
                flex: 1,
                child: LibraryCard(
                  displayImage: "images/R.png",
                  route: GalleryScreen(),
                )),
          ],
        ),
      ),
      _sectionHeader("Quotes"),
      Container(
        height: 200,
        child: Row(
          children: [
            new Flexible(
                flex: 1,
                child: LibraryCard(
                  displayImage: "images/Q.png",
                  route: Quotes(),
                )),
          ],
        ),
      ),
    ]);
  }
}

class LibraryCard extends StatelessWidget {
  final String displayImage;
  final Widget route;
  const LibraryCard({Key? key, required this.displayImage, required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 8.0, left: 8.0),
      child: InkWell(
        onTap: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route)),
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.grey.shade600, blurRadius: 7.0),
              ],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(displayImage), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
