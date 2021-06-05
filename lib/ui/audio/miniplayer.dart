// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/streams/streams.dart';
// import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:provider/provider.dart';

// This class provides a custom shape to the slider for Miniplayer
class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = 0;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class Miniplayer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaState>(
      stream: CustomStream.mediaStateStream,
      builder: (context, snapshot) {
        return AnimatedContainer(
            height: snapshot.hasData && snapshot.data.showMiniPlayer() ? 80 : 0,
            duration: Duration(milliseconds: 200),
            // Provide an optional curve to make the animation feel smoother.
            curve: Curves.easeIn,
            child: ColoredBox(
              color: Color(0xFF42A5F5),
              child: Column(
                children: [
                  SizedBox(
                    height: 4,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: CustomTrackShape(),
                        trackHeight: 2.0,
                        // thumbColor: Color(0xFFEB1555),
                        inactiveTrackColor: Color(0xFF8D8E98),
                        // activeTrackColor: Colors.white,
                        // overlayColor: Color(0x99EB1555),
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                        // overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                      ),
                      child: Slider(
                        min: 0,
                        max: snapshot.hasData ? snapshot.data.getMaxDuration().inMilliseconds.toDouble() + 100 : 1,
                        value: snapshot.hasData ? snapshot.data.getCurrentDuration().inMilliseconds.toDouble() : 0,
                        onChanged: null,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
                            child: CircleAvatar(backgroundImage: NetworkImage('https://i.postimg.cc/RZJ6HJrw/c.jpg')),
                          ),
                        ),
                        Expanded(flex: 4, child: Center(child: snapshot.hasData ? Column(
                          children: [
                            Text(snapshot.data.getMediaItemTitle(), style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis,),
                            Text(snapshot.data.getMediaItemSubtitle(), style: TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis,),
                          ],
                        ): Container())),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                                onTap: () {
                                  // if audio is playing and user clicks on the button for the audio that is playing then pause audio
                                  // if (currentAudio.isPlaying) {
                                  //   currentAudio.pauseAudio();
                                  // } else if (!currentAudio.isPlaying) { // if not audio is playing, simply start playing current audio
                                  //   currentAudio.playAudio();
                                  // }
                                },
                                child: Icon(true ? Icons.pause : Icons.play_arrow))),
                      ],),
                    ),
                  ),
                ],
              ),
            ),
          );
      }
    );

  }
}