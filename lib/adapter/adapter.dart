import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';

class Adapter {

  static MediaItem audioToMediaItem(Audio? audio) {
    return MediaItem(
      id: audio?.id ?? '',
      album: 'BDD Swami Vani',
      title: audio?.name ?? '',
      artUri: Uri.parse('https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg'),
      extras: {
        'url': audio?.url,
        'subtitle': audio?.name ?? 'Subtitle here',
      }
    );
  }

  static Audio mediaItemToAudio(MediaItem? mediaItem) {
    // TODO: Add album, subtitle and change name to title
    return Audio(
        id: mediaItem?.id ?? '',
        // album: 'BDD Swami Vani',
        name: mediaItem?.title ?? '',
        // subtitle: mediaItem?.extras?['url'] ?? 'Custom Subtitle',
        url: mediaItem?.extras?['url'] ?? '',
        // artUri: Uri.parse('https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg'),
    );
  }

  static MediaItem firebaseAudioSnapshotToMediaItem(QueryDocumentSnapshot<Object?> doc) {
    return MediaItem(
        id: doc['id'] ?? '',
        album: 'BDD Swami Vani',
        title: doc['name'] ?? '',
        artUri: Uri.parse('https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg'),
        extras: {
          'url': doc['url'] ?? '',
          'subtitle': doc['subtitle'] ?? 'Subtitle here',
        }
    );
  }

  static Audio firebaseAudioSnapshotToAudio(QueryDocumentSnapshot<Object?> doc) {
    return Audio(
        id: doc['id'] ?? '',
        name: doc['name'] ?? '',
        url: doc['url'] ?? ''
    );
  }

}