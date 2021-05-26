import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';

// const kShadowColor = Color.fromRGBO(72, 76, 82, 0.16);
var dividerTextStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20.0,
  decoration: TextDecoration.none,
);

class LibraryHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          _sectionHeader("Vani"),
          Container(
            height: 200,
            child: Row(
              children: [
                new Flexible(flex: 1, child: GalleryCard(displayString: "Audios", displayImage: "https://i.postimg.cc/3Jc0NCqK/A.jpg", route: AudioListScreen())),
                new Flexible(flex: 1, child: GalleryCard(displayString: "Videos", displayImage: "https://i.postimg.cc/1zxgcRP2/B.jpg", route: AudioPlayScreen(),)),
              ],
            ),
          ),
          _sectionHeader("Darshan"),
          Container(
            height: 200,
            child: Row(
              children: [
                new Flexible(flex: 1, child: GalleryCard(displayString: "Radha Shyam Sundar", displayImage: "https://bddswami.com/wp-content/uploads/2020/07/rs02-1.jpg")),
                new Flexible(flex: 1, child: GalleryCard(displayString: "Maharaja", displayImage: "https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg")),
              ],
            ),
          ),
          _sectionHeader("Kirtans"),
          Container(
            height: 200,
            child: Row(
              children: [
                new Flexible(flex: 1, child: GalleryCard(displayString: "Kirtans", displayImage: "https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(thickness: 1, endIndent: 8, color: Colors.black,)),
          Text(text, style: dividerTextStyle,),
          Expanded(child: Divider(thickness: 1, indent: 8, color: Colors.black,)),
        ],
      ),
    );
  }

}

class GalleryCard extends StatelessWidget {

  final String displayString;
  final String displayImage;
  final Widget route;
  const GalleryCard({Key key, this.displayString, this.displayImage, this.route}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () => {
          if (route != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => route)),
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: NetworkImage(displayImage), fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              Spacer(),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
                child: Center(
                  child: Text(displayString, style: new TextStyle(fontSize: 18.0),),
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
