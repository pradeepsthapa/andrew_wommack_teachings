import 'package:andrew_wommack/audio/media_state.dart';
import 'package:andrew_wommack/audio/queue_state.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'audio_seekbar.dart';
import 'download_progress.dart';


class MiniPlayerWidget extends StatelessWidget {

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }

  double valueFromPercentageInRange(
      {required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double playerMinHeight = 60;
    double playerMaxHeight = size.height *.8;
    const miniPlayerPercentageDeclaration = 0.2;
    final maxImgSize = size.width * 0.7;

    return StreamBuilder<bool>(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox.shrink();
          }
          final running = snapshot.data ?? false;
          if(!running) return SizedBox();
        return StreamBuilder<QueueState>(
            stream: queueStateStream,
            builder: (context, snapshot) {
              final queueState = snapshot.data;
              final queue = queueState?.queue ?? [];
              final mediaItem = queueState?.mediaItem;

              if(AudioService.connected)
                return Miniplayer(
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

                  return Material(
                    child: StreamBuilder<MediaState>(
                        stream: mediaStateStream,
                      builder: (context, snapshot) {
                        final mediaState = snapshot.data;
                        if(mediaState==null) return SizedBox.shrink();
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: paddingLeft,
                                    top: paddingVertical,
                                    bottom: paddingVertical),
                                child: Container(
                                  height: imageSize,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.network(mediaState.mediaItem?.artUri?.toString()??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Opacity(
                                  opacity: percentageExpandedPlayer,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SeekBar(
                                        duration: mediaState.mediaItem?.duration?? Duration.zero,
                                        position: mediaState.position,
                                        onChangeEnd: (newPosition) {
                                          AudioService.seekTo(newPosition);
                                        },
                                      ),
                                      Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 12),
                                            child: Text(mediaItem?.title??'', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                          ),
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 7),
                                            child: Text(mediaItem?.album??'', style: TextStyle(fontSize: 15),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                          ),

                                  ],
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                              onPressed: (){},
                                              icon: Icon(Icons.shuffle,)),
                                          IconButton(
                                              onPressed: mediaItem == queue.first ? null : AudioService.skipToPrevious,
                                              icon: Icon(Icons.skip_previous_rounded)),
                                          StreamBuilder<AudioProcessingState>(
                                            stream: AudioService.playbackStateStream.map((state) => state.processingState).distinct(),
                                            builder: (context, snapshot) {
                                              final processingState = snapshot.data ?? AudioProcessingState.none;
                                              return StreamBuilder<bool>(
                                                  stream: AudioService.playbackStateStream.map((state) => state.playing).distinct(),
                                                  builder: (context, snapshot) {
                                                    final playing = snapshot.data ?? false;
                                                    return IconButton(
                                                      iconSize: 50,
                                                      onPressed: playing?AudioService.pause:AudioService.play,
                                                      icon: CircleAvatar(
                                                        backgroundColor: Theme.of(context).primaryColor,
                                                        minRadius: 50,
                                                        child:processingState==AudioProcessingState.buffering?
                                                        CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 3,)
                                                            :Icon(playing?Icons.pause:Icons.play_arrow,color: Colors.white,size : 30,),
                                                      ),
                                                    );
                                                  }
                                              );
                                            },
                                          ),

                                          IconButton(
                                              onPressed: mediaItem == queue.last? null: AudioService.skipToNext,
                                              icon: Icon(Icons.skip_next_rounded)),
                                          IconButton(
                                              onPressed: (){
                                                queueDownload(context,mediaItem!.id, mediaItem.title);
                                              },
                                              icon: Icon(Icons.download_rounded)),
                                        ],
                                      ),
                                      DownloadProgressWidget()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],);
                      }
                    ),
                  );

                }

                final percentageMiniPlayer = percentageFromValueInRange(
                    min: playerMinHeight,
                    max: playerMaxHeight * miniPlayerPercentageDeclaration + playerMinHeight,
                    value: height);

                final elementOpacity = 1 - 1 * percentageMiniPlayer;
                final progressIndicatorHeight = 4 - 4 * percentageMiniPlayer;

                return StreamBuilder<MediaState>(
                    stream: mediaStateStream,
                  builder: (context, snapshot) {
                      final mediaState = snapshot.data;
                      if(mediaState==null) return SizedBox.shrink();

                      double valueFromPosition(
                          {required final Duration? current, required Duration? total}) {
                        return current!.inSeconds/total!.inSeconds;
                      }
                    return Material(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: maxImgSize),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(mediaState.mediaItem?.artUri?.toString()??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',fit: BoxFit.cover,)),
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
                                          Text(mediaItem?.title??'',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w700),),
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
                                            onPressed: mediaItem == queue.first ? null : AudioService.skipToPrevious,
                                            icon: Icon(EvaIcons.skipBack)),
                                        StreamBuilder<AudioProcessingState>(
                                          stream: AudioService.playbackStateStream.map((state) => state.processingState).distinct(),
                                          builder: (context, snapshot) {
                                            final processingState = snapshot.data ?? AudioProcessingState.none;
                                            return StreamBuilder<bool>(
                                                stream: AudioService.playbackStateStream.map((state) => state.playing).distinct(),
                                                builder: (context, snapshot) {
                                                  final playing = snapshot.data ?? false;
                                                  return IconButton(
                                                    iconSize: 30,
                                                    onPressed: playing?AudioService.pause:AudioService.play,
                                                    icon: processingState==AudioProcessingState.buffering?
                                                    Container(height:24,width: 24,child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(isDark?Colors.white:Colors.black,),strokeWidth: 3,))
                                                        :Icon(playing?EvaIcons.pauseCircle:EvaIcons.playCircle,size: 30,),
                                                  );
                                                }
                                            );
                                          },
                                        ),

                                        IconButton(
                                            onPressed: mediaItem == queue.last ? null : AudioService.skipToNext,
                                            icon: Icon(EvaIcons.skipForward,)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // if(mediaState.mediaItem?.duration!=null)
                            SizedBox(
                            height: progressIndicatorHeight,
                            child: Opacity(
                              opacity: elementOpacity,
                              child: LinearProgressIndicator(
                                value: mediaState.mediaItem?.duration==null?null:valueFromPosition(
                                    current: mediaState.position,
                                    total: mediaState.mediaItem?.duration??Duration.zero),),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                );
              },
            );
              return SizedBox();
          }
        );
      }
    );
  }

  void queueDownload(BuildContext context, String url, String filename) async{
    final downloader = context.read(audioDownloaderProvider);
    bool granted = await downloader.checkRequest();
    if(granted){
      downloader.startDownload(url, filename);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Permission denied. Please allow storage permission.",overflow: TextOverflow.ellipsis,)));
    }
  }
}
