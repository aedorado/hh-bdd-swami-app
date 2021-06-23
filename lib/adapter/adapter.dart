import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/models/podo/album.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';

class Adapter {
  static MediaItem audioToMediaItem(Audio? audio) {
    return MediaItem(
        id: audio?.id ?? '',
        album: 'BDD Swami Vani',
        title: audio?.name ?? '',
        artUri: Uri.parse(
            'https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg'),
        extras: {
          'url': audio?.url,
          'subtitle': audio?.name ?? 'Subtitle here',
        });
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

  static MediaItem firebaseAudioSnapshotToMediaItem(
      QueryDocumentSnapshot<Object?> doc) {
    return MediaItem(
        id: doc['id'] ?? '',
        album: 'BDD Swami Vani',
        title: doc['name'] ?? '',
        artUri: Uri.parse(
            'https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg'),
        extras: {
          'url': doc['url'] ?? '',
          'subtitle': doc['subtitle'] ?? 'Subtitle here',
        });
  }

  static Audio firebaseAudioSnapshotToAudio(
      QueryDocumentSnapshot<Object?> doc) {
    return Audio(
        id: doc['id'] ?? '', name: doc['name'] ?? '', url: doc['url'] ?? '');
  }

  static AudioFolder firebaseAudioFolderSnapshotToAudioFolder(
      QueryDocumentSnapshot<Object?> doc) {
    debugPrint('${doc.data()}');
    return AudioFolder(
        id: doc['id'] ?? '',
        name: doc['name'] ?? '',
        contentUrl: doc['contentUrl'] ?? '',
        totalContents: doc['totalContents'] ?? '');
  }

  static Album firebaseAlbumsSnapshotToAlbum(
      QueryDocumentSnapshot<Object?> doc) {
    return Album(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      coverUrl: doc['cover_url'] ?? '',
      totalImages: doc['total_images'] ?? '',
      totalVideos: doc['total_videos'] ?? '',
      description: doc['description'] ?? '',
    );
  }

  static GalleryImage firebaseAlbumsSnapshotToGalleryImage(
      QueryDocumentSnapshot<Object?> doc) {
    return GalleryImage(
      id: doc['id'] ?? '',
      description: doc['description'] ?? '',
      albumID: doc['album_id'] ?? '',
      color: doc['color'] ?? '',
      date: doc['date'] ?? '',
      displayURL: doc['display_url'] ?? '',
      downloadURL: doc['download_url'] ?? '',
      thumbnailURL: doc['thumbnail_url'] ?? '',
      location: doc['location'] ?? '',
      tags: doc['tags'] ?? '',
      type: doc['type'] ?? '',
    );
  }
}
