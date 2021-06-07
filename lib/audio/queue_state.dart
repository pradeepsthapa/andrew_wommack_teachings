import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class QueueState {
  final List<MediaItem>? queue;
  final MediaItem? mediaItem;

  QueueState(this.queue, this.mediaItem);
}

Stream<QueueState> get queueStateStream =>
    Rx.combineLatest2<List<MediaItem>?, MediaItem?, QueueState>(
        AudioService.queueStream,
        AudioService.currentMediaItemStream,
            (queue, mediaItem) => QueueState(queue, mediaItem));