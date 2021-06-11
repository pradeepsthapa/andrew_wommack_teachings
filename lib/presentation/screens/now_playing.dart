import 'package:andrew_wommack/audio/media_state.dart';
import 'package:andrew_wommack/audio/queue_state.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/widgets/audio_seekbar.dart';
import 'package:andrew_wommack/presentation/widgets/download_progress.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NowPlaying extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.chevron_left,size: 30,),onPressed: ()=>Navigator.pop(context),),
        title: Text("Now Playing",),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
                              // height: 240,width: size.width *.7,
                              child: CachedNetworkImage(fit: BoxFit.cover,height: 240,width: size.width *.7,
                                placeholder: (context, url) => Image.asset('assets/images/andrew_wommack.png'),
                                imageUrl: mediaState?.mediaItem?.artUri?.toString()??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
                                errorWidget: (context, url, error) => Image.network('https://www.podchaser.com/images/missing-image.png'),
                              )),
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
                              style: TextStyle(color: isDark?Theme.of(context).accentColor:Colors.white,fontWeight: FontWeight.bold,fontSize: 24),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
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
                                        iconSize: 60,
                                        onPressed: playing?AudioService.pause:AudioService.play,
                                        icon: CircleAvatar(
                                          backgroundColor: isDark?Colors.white:Colors.black45,
                                          minRadius: 60,
                                          child:processingState==AudioProcessingState.buffering?
                                          CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(isDark?Colors.black:Colors.white))
                                          :Icon(playing?Icons.pause:Icons.play_arrow,color: isDark?Colors.black:Colors.white,size : 40,),
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
                                  onPressed: (){
                                    queueDownload(context,mediaItem!.id, mediaItem.title);
                                  },
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
          Positioned(
              bottom: 0,left: 0,right: 0,
              child: DownloadProgressWidget()),
        ],
      ),
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
