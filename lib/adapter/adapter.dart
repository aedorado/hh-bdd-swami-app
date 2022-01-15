import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hh_bbds_app/models/podo/album.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';

class Adapter {
 static MediaItem audioToMediaItem(Audio? audio) {
   return MediaItem(
       id: audio?.id ?? '',
       album: 'BDD Swami Vani',
       title: audio?.name ?? '',
       artUri: Uri.parse(audio?.thumbnailUrl ?? ''),
       extras: {
         'url': audio?.url,
         'subtitle': audio?.name ?? 'Subtitle here',
         'thumbnailUrl': audio?.thumbnailUrl ?? '',
       });
 }

 static Audio mediaItemToAudio(MediaItem? mediaItem) {
   // TODO: Add album, subtitle and change name to title
   return Audio(
     id: mediaItem?.id ?? '',
     name: mediaItem?.title ?? '',
     url: mediaItem?.extras?['url'] ?? '',
     namePlainText: mediaItem?.extras?['namePlainText'] ?? '',
     thumbnailUrl: mediaItem?.extras?['thumbnailUrl'] ?? '',
   );
 }

 static MediaItem firebaseAudioSnapshotToMediaItem(
     QueryDocumentSnapshot<Object?> doc) {
   return MediaItem(
       id: doc['id'] ?? '',
       album: 'BDD Swami Vani',
       title: doc['name'] ?? '',
       extras: {
         'url': doc['url'] ?? '',
         'subtitle': doc['subtitle'] ?? 'Subtitle here',
         'thumbnailUrl': doc['thumbnailUrl'] ?? '',
       });
 }

 static Audio firebaseAudioSnapshotToAudio(
     QueryDocumentSnapshot<Object?> doc) {
   return Audio(
       id: doc['id'] ?? '',
       name: doc['name'] ?? '',
       url: doc['url'] ?? '',
       namePlainText: doc['namePlainText'] ?? '',
       thumbnailUrl: doc['thumbnailUrl'] ?? '');
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
}

