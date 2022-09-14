import 'package:andrew_wommack/audio/audio_task.dart';
import 'package:andrew_wommack/audio/media_state.dart';
import 'package:andrew_wommack/audio/queue_duration_stream.dart';
import 'package:andrew_wommack/audio/queue_state.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:miniplayer/miniplayer.dart';
import 'audio_seekbar.dart';


class MiniPlayerWidget extends ConsumerWidget {
  const MiniPlayerWidget({Key? key}) : super(key: key);

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }

  double valueFromPercentageInRange(
      {required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }

  static final _audioHandler = GetIt.I.get<AudioPlayerHandler>();

  static final MiniplayerController _controller = MiniplayerController();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double playerMinHeight = 60;
    double playerMaxHeight = size.height *.8;
    const miniPlayerPercentageDeclaration = 0.2;
    final maxImgSize = size.width * 0.7;

    return StreamBuilder<QueueState>(
        stream: _audioHandler.queueState,
        builder: (context, queueSnapshot) {
          if(queueSnapshot.connectionState!=ConnectionState.active){
            return const SizedBox.shrink();
          }
          final queueState = queueSnapshot.data;
          final queue = queueState?.queue ?? [];
          if(queue.isEmpty||queue.length<2){
            return const SizedBox.shrink();
          }
          else {
            return StreamBuilder(
              stream: _audioHandler.mediaItem,
              builder: (BuildContext context, AsyncSnapshot<MediaItem?> mediaSnapshot) {
                  final mediaItem = mediaSnapshot.data;
                  return Miniplayer(
                    controller: _controller,
                    backgroundColor: Colors.black54,
                    minHeight: playerMinHeight,
                    maxHeight: playerMaxHeight,
                    builder: (height,percentage){
                      final bool miniPlayer = percentage < miniPlayerPercentageDeclaration;
                      if(!miniPlayer){
                        var percentageExpandedPlayer = percentageFromValueInRange(
                            min: playerMaxHeight * miniPlayerPercentageDeclaration + playerMinHeight,
                            max: playerMaxHeight,
                            value: height);

                        if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
                        final paddingVertical = valueFromPercentageInRange(min: 0, max: 30, percentage: percentageExpandedPlayer);
                        final double heightWithoutPadding = height - paddingVertical * 2;
                        final double imageSize = heightWithoutPadding > maxImgSize ? maxImgSize : heightWithoutPadding;
                        final paddingLeft = valueFromPercentageInRange(min: 0, max: size.width - imageSize, percentage: percentageExpandedPlayer,) / 2;

                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: paddingLeft, top: paddingVertical, bottom: paddingVertical),
                                child: SizedBox(
                                  height: imageSize,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: mediaItem?.artUri?.toString()??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
                                        errorWidget: (_,__,___)=>Image.asset('assets/images/andrew_wommack.png'),
                                        placeholder: (_,__)=>Image.asset('assets/images/andrew_wommack.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Opacity(
                                opacity: percentageExpandedPlayer,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    StreamBuilder<PositionData>(
                                      stream: customPositionDataStream,
                                      builder: (context, snapshot) {
                                        final positionData = snapshot.data ?? PositionData(Duration.zero, Duration.zero, mediaItem?.duration ?? Duration.zero);
                                        return SeekBar(
                                          duration: positionData.duration,
                                          position: positionData.position,
                                          bufferedPosition: positionData.bufferedPosition,
                                          onChangeEnd: (newPosition) {
                                            _audioHandler.seek(newPosition);
                                          },
                                        );
                                      }
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 12),
                                          child: Text(mediaItem?.title??'',
                                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                        ),
                                        Padding(padding: const EdgeInsets.symmetric(vertical: 7),
                                          child: Text(mediaItem?.album??'', style: const TextStyle(fontSize: 15),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                        ),

                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          StreamBuilder<AudioServiceRepeatMode>(
                                            stream: _audioHandler.playbackState.map((event) => event.repeatMode).distinct(),
                                            builder: (context, repeatSnapshot) {
                                              const texts = ['None', 'All', 'One'];
                                              final repeatMode = repeatSnapshot.data ?? AudioServiceRepeatMode.none;
                                              final icons = [Icon(Icons.repeat_rounded, color: Theme.of(context).disabledColor), const Icon(Icons.repeat_rounded), const Icon(Icons.repeat_one_rounded)];
                                              const cycleModes = [AudioServiceRepeatMode.none, AudioServiceRepeatMode.all, AudioServiceRepeatMode.one];
                                              final cycleIndex = cycleModes.indexOf(repeatMode);
                                              return IconButton(
                                                  tooltip: 'Repeat ${texts[(cycleIndex + 1) % texts.length]}',
                                                  onPressed: (){
                                                    _audioHandler.setRepeatMode(cycleModes[
                                                    (cycleModes.indexOf(repeatMode) + 1) % cycleModes.length],
                                                    );
                                                  },
                                                  icon: icons[cycleIndex]);
                                            }
                                          ),
                                          IconButton(
                                              onPressed: mediaItem == queue.first ? null : _audioHandler.skipToPrevious,
                                              icon: const Icon(Icons.skip_previous_rounded)),
                                          StreamBuilder<PlaybackState>(
                                            stream: _audioHandler.playbackState,
                                            builder: (context, playbackSnapshot) {
                                              final playbackState = playbackSnapshot.data;
                                              final processingState = playbackState?.processingState;
                                              final playing = playbackState?.playing ?? false;
                                              // if (processingState == AudioProcessingState.idle) {
                                              //   return const SizedBox.shrink();
                                              // }
                                              return IconButton(
                                                iconSize: 50,
                                                onPressed: playing?_audioHandler.pause:_audioHandler.play,
                                                icon: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  minRadius: 50,
                                                  child:processingState==AudioProcessingState.buffering?
                                                  const CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 3,)
                                                      :Icon(playing?Icons.pause:Icons.play_arrow,color: Colors.white,size : 30,),
                                                ),
                                              );
                                            },
                                          ),

                                          IconButton(
                                              onPressed: mediaItem == queue.last? null: _audioHandler.skipToNext,
                                              icon: const Icon(Icons.skip_next_rounded)),
                                          IconButton(
                                              onPressed: (){
                                                // queueDownload(context,mediaItem!.id, mediaItem.title);
                                              },
                                              icon: const Icon(Icons.download_rounded)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],);
                      }

                      final percentageMiniPlayer = percentageFromValueInRange(min: playerMinHeight,
                          max: playerMaxHeight * miniPlayerPercentageDeclaration + playerMinHeight,
                          value: height);

                      final elementOpacity = 1 - 1 * percentageMiniPlayer;
                      final progressIndicatorHeight = 4 - 4 * percentageMiniPlayer;
                      double progressValue(double totalDuration, double currentPosition)=> currentPosition/totalDuration;

                      return Material(
                        color: Theme.of(context).cardColor,
                        child: Opacity(
                          opacity: elementOpacity,
                          child: Column(
                            children: [
                              Divider(height: 0,thickness: 1.3,color: Colors.grey[300]),
                              Expanded(
                                child: Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: maxImgSize),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: mediaItem?.artUri?.toString()??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
                                              errorWidget: (_,__,___)=>Image.asset('assets/images/andrew_wommack.png'),
                                              placeholder: (_,__)=>Image.asset('assets/images/andrew_wommack.png'),
                                            ),

                                      ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Opacity(
                                          opacity: elementOpacity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (mediaItem?.title != null)
                                                Text(mediaItem?.title??'',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontWeight: FontWeight.w700),),
                                              if (mediaItem?.album != null)
                                                Text(mediaItem?.album??'',maxLines: 1,overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (queue.isNotEmpty)
                                      Opacity(
                                        opacity: elementOpacity,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: mediaItem == queue.first ? null : _audioHandler.skipToPrevious,
                                                icon: const Icon(EvaIcons.skipBack)),
                                            StreamBuilder<PlaybackState>(
                                              stream: _audioHandler.playbackState,
                                              builder: (context, playbackSnapshot) {
                                                final playbackState = playbackSnapshot.data;
                                                final processingState = playbackState?.processingState;
                                                final playing = playbackState?.playing ?? false;
                                                // if (processingState == AudioProcessingState.idle) {
                                                //   return const SizedBox.shrink();
                                                // }
                                                return IconButton(
                                                  iconSize: 30,
                                                  onPressed: playing?_audioHandler.pause:_audioHandler.play,
                                                  icon: processingState==AudioProcessingState.buffering?
                                                  SizedBox(height:24,width: 24,child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(isDark?Colors.white:Colors.black,),strokeWidth: 3,))
                                                      :Icon(playing?EvaIcons.pauseCircle:EvaIcons.playCircle,size: 30,),
                                                );
                                              },
                                            ),

                                            IconButton(
                                                onPressed: mediaItem == queue.last ? null : _audioHandler.skipToNext,
                                                icon: const Icon(EvaIcons.skipForward,)),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // if(mediaState.mediaItem?.duration!=null)
                              SizedBox(
                                height: progressIndicatorHeight,
                                child: StreamBuilder<Duration>(
                                  stream: AudioService.position,
                                  builder: (context, durationSnapshot) {
                                    if(!durationSnapshot.hasData||durationSnapshot.data==null){
                                      return const SizedBox.shrink();
                                    }
                                    final position = durationSnapshot.data;
                                    return LinearProgressIndicator(
                                      value: progressValue(mediaItem?.duration?.inSeconds.toDouble()??0,position?.inSeconds.toDouble()??0),
                                    );
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
            );
          }
        }
    );
  }
}
