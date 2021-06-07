import 'package:andrew_wommack/audio/audio_task.dart';
import 'package:andrew_wommack/audio/queue_state.dart';
import 'package:andrew_wommack/data/model.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class FeedLoadedScreen extends StatelessWidget {
  final RssFeed? rssFeed;
  final TeachingModel? teachingModel;

  FeedLoadedScreen({@required this.rssFeed, @required this.teachingModel});


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      children: [
        Container(
          height: 220,color: Colors.black12,
          child: FadeInImage(
            placeholder: AssetImage('assets/images/andrew_wommack.png'),
            image: NetworkImage(rssFeed?.image?.url??'https://cachedimages.podchaser.com/512x512/aHR0cHM6Ly9kM3Qzb3pmdG1kbWgzaS5jbG91ZGZyb250Lm5ldC9wcm9kdWN0aW9uL3BvZGNhc3RfdXBsb2FkZWRfbm9sb2dvLzExODE5Njc5LzExODE5Njc5LTE2MTAxMTcxNjY1MzAtM2NlZDU4ZWIxZjFiMi5qcGc%3D/aHR0cHM6Ly93d3cucG9kY2hhc2VyLmNvbS9pbWFnZXMvbWlzc2luZy1pbWFnZS5wbmc%3D',),
            height: 220,width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(rssFeed?.title ?? teachingModel!.tTitle!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Text(
            rssFeed?.description ?? teachingModel!.description!, maxLines: 7,
            overflow: TextOverflow.ellipsis,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () async{
                  if(AudioService.running) {
                    await AudioService.stop().then((value) {
                      startAudioPlayer(feed: rssFeed);
                    });
                  }
                  else {
                    startAudioPlayer(feed: rssFeed);
                  }
                },
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.play_circle_fill_rounded, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text("PLAY ALL",
                      style: TextStyle(color: Colors.white),),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 0,
                minWidth: 150,
              ),
              Consumer(builder: (context, watch, child) {
                final state = watch(favouriteAudioProvider);
                return MaterialButton(
                  onPressed: () => context.read(favouriteAudioProvider).toggleFavourite(teachingModel!.tUrl!),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        state.readFavStatus(teachingModel!.tUrl!)?Icons.favorite:Icons.favorite_border_rounded,
                        color: state.readFavStatus(teachingModel!.tUrl!)?Theme.of(context).primaryColor:null,
                      ),
                      SizedBox(width: 10,),
                      Text("FAVOURITE",style: TextStyle(color: state.readFavStatus(teachingModel!.tUrl!)?Theme.of(context).primaryColor:null),),
                    ],
                  ),
                  color: isDark ? Colors.grey[800] : Colors.white,
                  highlightColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 0,
                  minWidth: 150,
                );
              },),
            ],
          ),
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: rssFeed?.items?.length ?? 0,
          itemBuilder: (context, index) {
            final item = rssFeed?.items?[index];
            return Consumer(
              builder: (context, watch, child) {
                return Card(
                  elevation: 5,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: StreamBuilder<QueueState>(
                    stream: queueStateStream,
                    builder: (context, snapshot) {
                      final queueState = snapshot.data;
                      final queue = queueState?.queue ?? [];
                      final mediaItem = queueState?.mediaItem;
                      return ListTile(
                        focusColor: Colors.red,
                        selected: item?.enclosure?.url==mediaItem?.id? true : false,
                        leading: SizedBox(width: 50, height: 50,
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 5,
                            shadowColor: Colors.black45,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FadeInImage(placeholder: AssetImage(
                                    'assets/images/andrew_wommack.png'),
                                  image: NetworkImage(rssFeed?.image?.url ??
                                      'https://assets-global.website-files.com/59ee0c0f13651700017e6ed2/5dd6c25b8a6cfb31eb7799fd_ccob.jpeg'),
                                  fit: BoxFit.cover,)),
                          ),
                        ),
                        title: Text(item?.title ?? '', style: TextStyle(
                            fontWeight: FontWeight.w500),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item?.description?.replaceAll(
                                RegExp(r"<[^>]*>"), '') ?? '', maxLines: 3,
                              overflow: TextOverflow.ellipsis,),
                            Align(alignment: Alignment.topRight,
                              child: Text(DateTime.parse(
                                  item?.pubDate?.toString() ??
                                      DateTime.now().toString())
                                  .toString()
                                  .substring(0, 10),
                                style: TextStyle(fontSize: 10),),)
                          ],
                        ),
                        onTap: () async{

                          if(queue.isNotEmpty&&queue.first.id==rssFeed?.items?[0].enclosure?.url){
                            AudioService.skipToQueueItem(item!.enclosure!.url!);
                          }
                          else {
                            if(AudioService.running) {
                              await AudioService.stop().then((value) {
                                startAudioPlayer(feed: rssFeed);
                              });
                            }
                            else {
                              startAudioPlayer(feed: rssFeed);
                            }
                          }
                        },
                      );
                    }
                  ),
                );
              },);
          },)
      ],
    );
  }

  void startAudioPlayer({@required RssFeed? feed}) {
    final List<Map<String, dynamic>> lists = [];
    for (int i = 0; i < feed!.items!.length; i++) {
      RssItem item = feed.items![i];
      MediaItem media = MediaItem(
          id: item.enclosure?.url ?? '',
          album: feed.title ?? 'Andrew Wommack',
          title: item.title ?? 'Andrew Wommack',
          artist: feed.author ?? 'Andrew Wommack',
          // duration: Duration(milliseconds: item.enclosure?.length ?? 0,),
          artUri: Uri.parse(feed.image?.url ?? 'https://assets-global.website-files.com/59ee0c0f13651700017e6ed2/5dd6c25b8a6cfb31eb7799fd_ccob.jpeg')
      );
      lists.add(media.toJson());
    }

    AudioService.start(
        backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
        androidNotificationChannelName: 'Andrew Wommack Teachings',
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
        params: {"data": lists}
    );
  }
}
