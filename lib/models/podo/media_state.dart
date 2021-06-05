import 'package:audio_service/audio_service.dart';

class MediaState {
  final MediaItem mediaItem;
  final Duration position;
  final PlaybackState playbackState;

  MediaState(this.mediaItem, this.position, this.playbackState) {
    // debugPrint('MID=${this.mediaItem.duration.toString()} POS=${this.position.toString()} PBStatePlaying=${this.playbackState.playing} ProsState=${this.playbackState.processingState.toString()}');
  }

  bool showMiniPlayer() {
    return (this.playbackState != null
        && (this.playbackState.processingState == AudioProcessingState.ready
            || this.playbackState.processingState == AudioProcessingState.completed));
  }

  Duration getMaxDuration() {
    if (this.mediaItem != null) {
      return this.mediaItem.duration;
    }
    return Duration(milliseconds: 0);
  }

  Duration getCurrentDuration() {
    if (this.position != null) {
      return this.position;
    }
    return Duration(milliseconds: 0);
  }

  String getMediaItemTitle() {
    return (this.mediaItem != null) ? this.mediaItem.title: '';
  }

  String getMediaItemSubtitle() {
    return (this.mediaItem != null) ? this.mediaItem.extras['subtitle']: '';
  }
  
  bool shouldPause() {
    return (this.playbackState != null && this.playbackState.playing);
  }

  bool shouldReplay() {
    return (this.playbackState != null && this.playbackState.processingState == AudioProcessingState.completed);
  }

  bool shouldShowPauseIcon() {
    return (this.playbackState != null && this.playbackState.playing && this.playbackState.processingState != AudioProcessingState.completed);
  }

}