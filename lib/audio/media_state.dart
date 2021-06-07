import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

Stream<MediaState> get mediaStateStream => Rx.combineLatest2<MediaItem?, Duration, MediaState>(
        AudioService.currentMediaItemStream,
        AudioService.positionStream,
            (mediaItem, position) => MediaState(mediaItem, position));