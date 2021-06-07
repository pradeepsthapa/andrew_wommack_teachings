import 'dart:ui';

import 'package:andrew_wommack/audio/media_state.dart';
import 'package:andrew_wommack/audio/queue_state.dart';
import 'package:andrew_wommack/presentation/widgets/audio_seekbar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class NowPlaying extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.chevron_left,size: 30,),onPressed: ()=>Navigator.pop(context),),
        title: Text("Now Playing",),
      ),
      body: Container(
        height: size.height,width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
            stops: [0.2,0.4,0.5,0.7],
            begin: Alignment.topCenter,end: Alignment.bottomRight
          )
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 100,),
            StreamBuilder<MediaState>(
              stream: mediaStateStream,
              builder: (context, snapshot) {
                final mediaState = snapshot.data;
                return Column(mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration:BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black12,offset: Offset(-7,9),blurRadius: 7),
                          BoxShadow(color: Colors.black12,offset: Offset(7,9),blurRadius: 9),
                        ]
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: FadeInImage(placeholder: AssetImage('assets/images/andrew_wommack.png'), image: NetworkImage(mediaState?.mediaItem?.artUri?.toString()??'https://cachedimages.podchaser.com/512x512/aHR0cHM6Ly9kM3Qzb3pmdG1kbWgzaS5jbG91ZGZyb250Lm5ldC9wcm9kdWN0aW9uL3BvZGNhc3RfdXBsb2FkZWRfbm9sb2dvLzExODE5Njc5LzExODE5Njc5LTE2MTAxMTcxNjY1MzAtM2NlZDU4ZWIxZjFiMi5qcGc%3D/aHR0cHM6Ly93d3cucG9kY2hhc2VyLmNvbS9pbWFnZXMvbWlzc2luZy1pbWFnZS5wbmc%3D',),
                              height: 240,width: size.width *.7,
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(height: 50,),
                    SeekBar(
                      duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                      position: mediaState?.position ?? Duration.zero,
                      onChangeEnd: (newPosition) {
                        AudioService.seekTo(newPosition);
                      },
                    ),
                  ],
                );
                return SizedBox();
              },
            ),
            SizedBox(),
            StreamBuilder<QueueState>(
              stream: queueStateStream,
              builder: (context,snapshot){
                final queueState = snapshot.data;
                final queue = queueState?.queue ?? [];
                final mediaItem = queueState?.mediaItem;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Padding(padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                        child: Text(mediaItem?.title??'',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                        child: Text(mediaItem?.album??'',
                            style: TextStyle(color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                      ),
                    SizedBox(height: 20,),
                    if (queue.isNotEmpty)
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.shuffle,color: Colors.white,)),
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
                                    iconSize: 50,
                                    onPressed: playing?AudioService.pause:AudioService.play,
                                    icon: CircleAvatar(
                                      backgroundColor: Colors.black45,
                                      minRadius: 50,
                                      child:processingState==AudioProcessingState.buffering?
                                      CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.white))
                                      :Icon(playing?Icons.pause:Icons.play_arrow,color: Colors.white,size: 30,),
                                    ),
                                  );
                                }
                              );
                            },
                          ),

                          IconButton(
                              onPressed: mediaItem == queue.last? null: AudioService.skipToNext,
                              icon: Icon(Icons.skip_next_rounded,color: Colors.white,)),
                          IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.download_rounded,color: Colors.white,)),
                        ],
                      ),

                  ],
                );
              },
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
