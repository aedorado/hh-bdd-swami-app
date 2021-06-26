import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_audios.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_images.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_constants.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_home.dart';
import 'package:hh_bbds_app/ui/quotes/quotes_screen.dart';

var dividerTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  decoration: TextDecoration.none,
);

class LibraryHome extends StatelessWidget {
  bool isFavoritesLibrary = false;

  LibraryHome({required this.isFavoritesLibrary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(scrollDirection: Axis.vertical, children: this.isFavoritesLibrary ? _getFavoritesLibraryContent() : _getGeneralibraryContent()),
    );
  }

  _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 1,
            endIndent: 8,
            color: Colors.black,
          )),
          Text(
            text,
            style: dividerTextStyle,
          ),
          Expanded(
              child: Divider(
            thickness: 1,
            indent: 8,
            color: Colors.black,
          )),
        ],
      ),
    );
  }

  _getFavoritesLibraryContent() {
    return <Widget>[
      _sectionHeader("Vani"),
      Container(
        height: 200,
        child: Row(
          children: [
            new Flexible(flex: 1, child: LibraryCard(displayString: "Audios", displayImage: "images/A.jpg", route: FavoriteAudios())),
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
                  displayString: "Radha Shyama Sundar & Maharaja",
                  displayImage: "images/R.jpg",
                  route: FavoriteImages(),
                )),
            // new Flexible(
            //     flex: 1,
            //     child: LibraryCard(
            //       displayString: "Maharaja",
            //       displayImage: "images/D.jpg",
            //       route: FavoriteImages(),
            //     )),
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
                  displayString: "Quotes",
                  displayImage: "images/Q.jpg",
                  route: Quotes(),
                )),
          ],
        ),
      ),
    ];
  }

  _getGeneralibraryContent() {
    return <Widget>[
      _sectionHeader("Vani"),
      Container(
        height: 200,
        child: Row(
          children: [
            new Flexible(flex: 1, child: LibraryCard(displayString: "Audios", displayImage: "images/A.jpg", route: AudioListScreen())),
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
                  displayString: "Sri Sri Radha Shyama Sundar",
                  displayImage: "images/R.jpg",
                  route: GalleryHome(
                    galleryOperateMode: GalleryOperateMode.OPERATE_MODE_RSS,
                  ),
                )),
            new Flexible(
                flex: 1,
                child: LibraryCard(
                  displayString: "Maharaja",
                  displayImage: "images/D.jpg",
                  route: GalleryHome(
                    galleryOperateMode: GalleryOperateMode.OPERATE_MODE_MHR,
                  ),
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
                  displayString: "Quotes",
                  displayImage: "images/Q.jpg",
                  route: Quotes(),
                )),
          ],
        ),
      ),
    ];
  }
}

class LibraryCard extends StatelessWidget {
  final String displayString;
  final String displayImage;
  final Widget route;
  const LibraryCard({Key? key, required this.displayString, required this.displayImage, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) => route)),
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage(displayImage), fit: BoxFit.cover)),
          child: Column(
            children: [
              Spacer(),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
                child: Center(
                  child: Text(
                    displayString,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
