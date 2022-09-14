import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'audio_task.dart';
import 'media_state.dart';

final _audioHandler = GetIt.I.get<AudioPlayerHandler>();

Stream<Duration> get customBufferedPositionStream => _audioHandler.playbackState.map((state) => state.bufferedPosition).distinct();
Stream<Duration?> get customDurationStream => _audioHandler.mediaItem.map((item) => item?.duration).distinct();
Stream<PositionData> get customPositionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  AudioService.position,
  customBufferedPositionStream,
  customDurationStream, (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero),);