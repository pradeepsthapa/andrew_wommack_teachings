import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

void audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}


class AudioPlayerTask extends BackgroundAudioTask {

  AudioPlayer _player = new AudioPlayer();
  AudioProcessingState? _skipState;
  Seeker? _seeker;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  var _queue = <MediaItem>[];
  List<MediaItem> get queue => _queue;
  int? get index => _player.currentIndex;
  MediaItem? get mediaItem => index == null ? null : queue[index!];

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    print("onStart Started");
    _queue.clear();
    List items = params!["data"];
    for (int i=0;i<items.length; i++) {
      MediaItem mediaItem = MediaItem.fromJson(items[i]);
      _queue.add(mediaItem);
    }

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());

    _player.currentIndexStream.listen((index) {
      if (index != null) AudioServiceBackground.setMediaItem(queue[index]);
    });

    _eventSubscription = _player.playbackEventStream.listen((event) {
      _broadcastState();
    });

    _performSpecialProcessingForStateTransistions();

    AudioServiceBackground.setQueue(queue);



    try {
      await _player.setAudioSource(ConcatenatingAudioSource(
        children: _queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
      _player.durationStream.listen((duration) {
        if(duration != null) _updateQueueWithCurrentDuration(duration);
      });

      onPlay();
    } catch (e) {
      print("Error: $e");
      onStop();
    }
  }



  void _performSpecialProcessingForStateTransistions() {
    _player.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          onStop();
          break;
        case ProcessingState.ready:
          _skipState = null;
          break;
        default:
          break;
      }
    });
  }

  void _updateQueueWithCurrentDuration(Duration? duration) {
    final modifiedMediaItem = mediaItem!.copyWith(duration: duration);
    queue[index!] = modifiedMediaItem;
    AudioServiceBackground.setMediaItem(queue[index!]);
    AudioServiceBackground.setQueue(queue);
  }

  // void _loadMediaItemsIntoQueue(params) {
  //   final List<MediaItem> mediaItems = params['data'];
  //   print("print list jere $mediaItems");
  //   for (MediaItem item in mediaItems) {
  //     // final MediaItem mediaItem = MediaItem.fromJson(item);
  //     _queue.add(item);
  //   }
  // }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    final newIndex = queue.indexWhere((item) => item.id == mediaId);
    if (newIndex == -1) return;
    _skipState = newIndex > index! ? AudioProcessingState.skippingToNext : AudioProcessingState.skippingToPrevious;
    _player.seek(Duration.zero, index: newIndex);
    AudioServiceBackground.sendCustomEvent('skip to $newIndex');
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onSkipToNext() {
    return _player.seekToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    return _player.seekToPrevious();
  }

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);

  @override
  Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);

  // @override
  // Future<void> onAddQueueItem(MediaItem mediaItem) {
  //   _queue.add(mediaItem);
  //   AudioServiceBackground.setQueue(_queue);
  //   return super.onAddQueueItem(mediaItem);
  // }

  @override
  Future<void> onStop() async {
    await _player.stop();
    await _player.dispose();
    _eventSubscription.cancel();
    await super.onStop();
    await _broadcastState();
  }

  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem!.duration!) newPosition = mediaItem!.duration!;
    await _player.seek(newPosition);
  }

  void _seekContinuously(bool begin, int direction) {
    _seeker?.stop();
    if (begin) {
      _seeker = Seeker(_player, Duration(seconds: 10 * direction),
          Duration(seconds: 1), mediaItem!)
        ..start();
    }
  }

  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }
}

class Seeker {
  final AudioPlayer player;
  final Duration positionInterval;
  final Duration stepInterval;
  final MediaItem mediaItem;
  bool _running = false;

  Seeker(
      this.player,
      this.positionInterval,
      this.stepInterval,
      this.mediaItem,
      );

  start() async {
    _running = true;
    while (_running) {
      Duration newPosition = player.position + positionInterval;
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      if (newPosition > mediaItem.duration!) newPosition = mediaItem.duration!;
      player.seek(newPosition);
      await Future.delayed(stepInterval);
    }
  }

  stop() {
    _running = false;
  }
}