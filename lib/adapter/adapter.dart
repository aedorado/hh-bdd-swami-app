import 'package:audio_service/audio_service.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';

class Adapter {

  static MediaItem audioToMediaItem(Audio audio) {
    return MediaItem(
      id: audio.id,
      album: 'BDD Swami Vani',
      title: audio.name,
      artUri: 'https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg',
      extras: {
        'url': audio.url
      }
    );
  }

}