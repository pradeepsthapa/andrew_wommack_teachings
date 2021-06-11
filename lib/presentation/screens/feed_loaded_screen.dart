import 'package:andrew_wommack/audio/audio_task.dart';
import 'package:andrew_wommack/audio/queue_state.dart';
import 'package:andrew_wommack/data/model.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          child: CachedNetworkImage(fit: BoxFit.cover,height: 220,
            placeholder: (context, url) => Image.asset('assets/images/andrew_wommack.png'),
            imageUrl: rssFeed?.image?.url??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
            errorWidget: (context, url, error) => Image.network('https://www.podchaser.com/images/missing-image.png'),
          ),

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(rssFeed?.title ?? teachingModel!.tTitle!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color: isDark?Theme.of(context).accentColor:Colors.black),),
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
                      startAudioPlayer(feed: rssFeed,teachingModel: teachingModel);
                    });
                  }
                  else {
                    startAudioPlayer(feed: rssFeed,teachingModel: teachingModel);
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
                  onPressed: () {
                    context.read(favouriteAudioProvider).toggleFavourite(teachingModel!.tUrl!);
                    // print(rssFeed?.image?.url??'no link');
                  },
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
                        selected: item?.enclosure?.url==mediaItem?.id? true : false,
                        leading: SizedBox(width: 50, height: 50,
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 5,
                            shadowColor: Colors.black45,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset('assets/images/andrew_wommack.png'),
                                  imageUrl: rssFeed?.image?.url??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
                                  errorWidget: (context, url, error) => Image.network('https://www.podchaser.com/images/missing-image.png'),
                                )),
                          ),
                        ),
                        title: Text(item?.title ?? '', style: TextStyle(
                            fontWeight: item?.enclosure?.url==mediaItem?.id?FontWeight.bold:FontWeight.w500),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item?.description?.replaceAll(
                                RegExp(r"<[^>]*>"), '') ?? '', maxLines: 3,
                              overflow: TextOverflow.ellipsis,),
                            // Align(alignment: Alignment.topRight,
                            //   child: Text(DateTime.parse(item?.pubDate?.toString() ??
                            //           DateTime.now().toString()).toString().substring(0, 10),
                            //     style: TextStyle(fontSize: 10),),)
                          ],
                        ),
                        onTap: () async{

                          if(queue.isNotEmpty&&queue.first.id==rssFeed?.items?[0].enclosure?.url){
                            AudioService.skipToQueueItem(item!.enclosure!.url!);
                          }
                          else {
                            if(AudioService.running) {
                              await AudioService.stop().then((value) {
                                startAudioPlayer(feed: rssFeed,teachingModel: teachingModel);
                              });
                            }
                            else {
                              startAudioPlayer(feed: rssFeed,teachingModel: teachingModel);
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

  void startAudioPlayer({@required RssFeed? feed, @required TeachingModel? teachingModel}) {
    final List<Map<String, dynamic>> lists = [];
    for (int i = 0; i < feed!.items!.length; i++) {
      RssItem item = feed.items![i];
      MediaItem media = MediaItem(
          id: item.enclosure?.url ?? '',
          album: feed.title ?? teachingModel!.tTitle!,
          title: item.title ?? teachingModel!.tTitle!,
          artist: feed.author ?? 'Andrew Wommack',
          // duration: Duration(milliseconds: item.enclosure?.length ?? 0,),
          artUri: Uri.parse(feed.image?.url ?? teachingModel?.image??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg')
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
