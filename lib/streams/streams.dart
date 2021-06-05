import 'package:audio_service/audio_service.dart';
import 'package:hh_bbds_app/models/podo/media_state.dart';
import 'package:rxdart/rxdart.dart';

class CustomStream {

  static Stream<MediaState> get mediaStateStream =>
      Rx.combineLatest3<MediaItem, Duration, PlaybackState, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          AudioService.playbackStateStream,
              (mediaItem, position, playBackState) => MediaState(mediaItem, position, playBackState));

}


