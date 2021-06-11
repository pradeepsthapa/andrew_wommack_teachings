import 'package:andrew_wommack/logic/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadProgressWidget extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final downloadState = watch(audioDownloaderProvider);
    if(downloadState.downloadTaskStatus== DownloadTaskStatus.running)
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text("Downloading...${downloadState.progress}"+"%",style: TextStyle(color: Colors.white,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.greenAccent,
                    inactiveTrackColor: Colors.transparent,
                    trackHeight: 3,
                    thumbColor: Colors.greenAccent,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 1.0),
                    overlayColor: Colors.transparent,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 2),),
                  child: Slider(
                    min: 0.0,
                    max: 100.0,
                    value: downloadState.progress.toDouble(),
                    onChanged: (newPosition) {
                    },),
                ),
              ),
            ],
          ),
        ),
        IconButton(onPressed: ()=>context.read(audioDownloaderProvider).cancelDownload(downloadState.id), icon: Icon(Icons.close,color: Colors.white,size: 18,)),
      ],
    );
    if(downloadState.downloadTaskStatus==DownloadTaskStatus.complete){
      Future.delayed((Duration(milliseconds: 500)),(){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download Completed."),));
      });
    }
    if(downloadState.downloadTaskStatus==DownloadTaskStatus.canceled){
      Future.delayed((Duration(milliseconds: 500)),(){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download cancelled!"),));
      });
    }
    return SizedBox();
  }
}
