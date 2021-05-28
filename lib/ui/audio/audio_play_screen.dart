import 'package:flutter/material.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:provider/provider.dart';

var audioTitleStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20.0,
  decoration: TextDecoration.none,
);

class AudioPlayScreen extends StatefulWidget {
  @override
  _AudioPlayScreenState createState() => _AudioPlayScreenState();
}

class _AudioPlayScreenState extends State<AudioPlayScreen> {
  double _audioSliderPos = 0;
  bool playing = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BDD Swami App"), backgroundColor: Colors.blue[800]),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[800],
                Colors.blue[200],
              ]),
        ),
        child: Column(
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
            Container(
              child: Column(
                children: [
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
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<CurrentAudio>(
                          builder: (context, currentAudio, child) => InkWell(
                            onTap: () {
                              currentAudio.isPlaying ? currentAudio.pauseAudio() : currentAudio.playAudio();
                            },
                            child: Container(
                              child: Center(
                                  child: Icon( currentAudio.isPlaying ? Icons.pause : Icons.play_arrow, size: 50,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                ],
              ),
            ),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
