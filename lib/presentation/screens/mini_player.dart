import 'package:andrew_wommack/audio/media_state.dart';
import 'package:andrew_wommack/audio/queue_state.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'now_playing.dart';

class MiniPlayer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<bool>(
      stream: AudioService.runningStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return SizedBox();
        }
        final running = snapshot.data ?? false;
        if(!running) return SizedBox();
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) =>
                NowPlaying()));
          },
          child: Container(
            height: 60,width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ]
              )
            ),
            child: Column(
              children: [
                StreamBuilder<QueueState>(
                  stream: queueStateStream,
                  builder: (context,snapshot){
                    final queueState = snapshot.data;
                    final queue = queueState?.queue ?? [];
                    final mediaItem = queueState?.mediaItem;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 50,width: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                              child: Image.asset('assets/images/andrew_wommack.png')),
                        ),
                        Flexible(flex:4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            if (mediaItem?.title != null)
                              Text(mediaItem!.title,maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            if(mediaItem?.album !=null) Text(mediaItem!.album,maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white70,),
                            ),
                          ],),
                        ),
                        if (queue.isNotEmpty)
                          Flexible(flex: 4,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: mediaItem == queue.first ? null : AudioService.skipToPrevious,
                                    icon: Icon(Icons.skip_previous_rounded,color: Colors.white,)),
                                StreamBuilder<AudioProcessingState>(
                                  stream: AudioService.playbackStateStream.map((state) => state.processingState).distinct(),
                                  builder: (context, snapshot) {
                                    final processingState = snapshot.data ?? AudioProcessingState.none;
                                    return StreamBuilder<bool>(
                                        stream: AudioService.playbackStateStream.map((state) => state.playing).distinct(),
                                        builder: (context, snapshot) {
                                          final playing = snapshot.data ?? false;
                                          return IconButton(
                                            iconSize: 40,
                                            onPressed: playing?AudioService.pause:AudioService.play,
                                            icon: CircleAvatar(
                                              backgroundColor: Colors.black45,
                                              minRadius: 40,
                                              child:processingState==AudioProcessingState.buffering?
                                              CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.white))
                                                  :Icon(playing?Icons.pause:Icons.play_arrow,color: Colors.white,),
                                            ),
                                          );
                                        }
                                    );
                                  },
                                ),

                                IconButton(
                                    onPressed: mediaItem == queue.last ? null : AudioService.skipToNext,
                                    icon: Icon(Icons.skip_next_rounded,color: Colors.white,)),
                              ],
                            ),
                          ),

                      ],
                    );
                  },
                ),
                StreamBuilder<MediaState>(
                  stream: mediaStateStream,
                    builder: (context,snapshot){
                    final mediaState = snapshot.data;
                    if(mediaState?.mediaItem?.duration==null) return SizedBox();
                    return SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.greenAccent,
                        inactiveTrackColor: Colors.transparent,
                        trackHeight: 1,
                        thumbColor: Colors.greenAccent,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 1.0),
                        overlayColor: Colors.transparent,
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 2),),
                      child: Slider(
                        min: 0.0,
                        max: mediaState?.mediaItem?.duration?.inSeconds.toDouble()??0.0,
                        value: mediaState?.position.inSeconds.toDouble()??0.0,
                        onChanged: (newPosition) {
                          // AudioService.seekTo(Duration(seconds: newPosition.round()));
                        },),
                    );
                    })
              ],
            ),
          ),
        );
      }
    );
  }
}
