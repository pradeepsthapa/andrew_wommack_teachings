import 'package:audio_service/audio_service.dart';

class MediaState {
  final MediaItem mediaItem;
  final Duration position;
  MediaState(this.mediaItem, this.position);
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}