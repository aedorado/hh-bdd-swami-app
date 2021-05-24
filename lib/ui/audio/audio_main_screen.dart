import 'package:flutter/material.dart';

var audioTitleStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20.0,
  decoration: TextDecoration.none,
);

class AudioMainPage extends StatefulWidget {
  @override
  _AudioMainPageState createState() => _AudioMainPageState();
}

class _AudioMainPageState extends State<AudioMainPage> {
  double _audioSliderPos = 0;
  bool playing = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        new Padding(
          padding:
              const EdgeInsets.only(left: 48, right: 48, top: 24, bottom: 12),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(
                        "https://i1.sndcdn.com/artworks-000674039176-uw34hj-t500x500.jpg"),
                    fit: BoxFit.cover)),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
          child: Text(
            "What Prahalad Maharaja learnt in the womb",
            style: audioTitleStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
          child: SliderTheme(
            data: SliderThemeData(
              // thumbColor: Color(0xFFEB1555),
              inactiveTrackColor: Color(0xFF8D8E98),
              // activeTrackColor: Colors.white,
              // overlayColor: Color(0x99EB1555),
              // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
              // overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
            ),
            child: Slider(
              min: 0,
              max: 100,
              value: _audioSliderPos,
              onChanged: (double value) {
                setState(() {
                  _audioSliderPos = value;
                });
              },
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    playing = !playing;
                  });
                },
                child: Container(
                  child: Center(
                      child: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    size: 50,
                  )),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Container(
                  child: Center(
                      child: IconTheme(
                          data: new IconThemeData(color: Colors.redAccent),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 50,
                          ))),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Spacer(),
      ],
    );
  }
}
