import 'package:andrew_wommack/audio/audio_task.dart';
import 'package:andrew_wommack/data/teaching_model.dart';
import 'package:andrew_wommack/logic/media_converter.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/widgets/facebook_native_widget.dart';
import 'package:andrew_wommack/presentation/widgets/mini_player_widget.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:webfeed/domain/rss_feed.dart';

class FeedLoadedScreen extends StatelessWidget {
  final RssFeed? rssFeed;
  final TeachingModel teachingModel;
  const FeedLoadedScreen({Key? key, required this.rssFeed, required this.teachingModel}) : super(key: key);

  static final _audioHandler = GetIt.I.get<AudioPlayerHandler>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<MediaItem?>(
          stream: _audioHandler.mediaItem,
          builder: (context, mediaSnapshot) {
            if(!mediaSnapshot.hasData||mediaSnapshot.data==null||mediaSnapshot.hasError){
              return const SizedBox.shrink();
            }
            final currentMedia = mediaSnapshot.data;

            return StreamBuilder<PlaybackState>(
              stream: _audioHandler.playbackState,
              builder: (context, playbackSnapshot) {
                final playbackState = playbackSnapshot.data;
                final playing = playbackState?.playing ?? false;
                final bool buffering = playbackState?.processingState==AudioProcessingState.loading || playbackState?.processingState == AudioProcessingState.buffering;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,height: 220,
                        width: double.infinity,
                        placeholder: (context, url) => Image.asset('assets/images/andrew_wommack.png'),
                        imageUrl: rssFeed?.image?.url??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
                        errorWidget: (context, url, error) => Image.asset('assets/images/andrew_wommack.png'),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(rssFeed?.title ?? teachingModel.tTitle,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.secondary),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Text(rssFeed?.description ?? teachingModel.description, maxLines: 7, overflow: TextOverflow.ellipsis,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: MaterialButton(
                          onPressed: () async{
                            final queue = _audioHandler.queue.value;
                            if(queue.first.id!=rssFeed?.items?.first.enclosure?.url){
                              final list = MediaConverter.rssToMediaList(feed: rssFeed!);
                              await _audioHandler.updateQueue(list);
                              _audioHandler.skipToQueueItem(0);
                              if(!playing) _audioHandler.play();
                            }
                          },
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          elevation: 0,
                          minWidth: 150,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle_fill_rounded, color: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white),
                              const SizedBox(width: 10),
                              Text("PLAY ALL", style: TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),indent: 12,endIndent: 12,),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rssFeed?.items?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = rssFeed?.items?[index];
                        return Card(
                          elevation: 5,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            selected: currentMedia?.id==item?.enclosure?.url,
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
                                      errorWidget: (context, url, error) => Image.network('https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg'),
                                    )),
                              ),
                            ),
                            title: Text(item?.title ?? '', style: const TextStyle(),),
                            trailing: Consumer(
                              builder: (context, ref,child) {
                                final favourites = ref.watch(favouritesProvider);
                                final bool isFavourite = favourites.contains(MediaConverter.rssToCustomMediaItem(rssItem: item!, feed: rssFeed!));
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                    onPressed: (){
                                    if(isFavourite){
                                      ref.read(favouritesProvider.notifier).removeBookmark(customMediaItem: MediaConverter.rssToCustomMediaItem(rssItem: item, feed: rssFeed!));
                                    }else if(!isFavourite){
                                      ref.read(favouritesProvider.notifier).addBookmark(customMediaItem: MediaConverter.rssToCustomMediaItem(rssItem: item, feed: rssFeed!));
                                    }
                                    }, icon: Icon(isFavourite?Icons.favorite:Icons.favorite_border,size: 15));
                              }
                            ),
                            subtitle: Text(
                              item?.description?.replaceAll(RegExp(r"<[^>]*>"), '') ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,),
                            onTap: () async{
                              if(!buffering){
                                final queue = _audioHandler.queue.value;
                                if(queue.first.id!=rssFeed?.items?.first.enclosure?.url){
                                  final list = MediaConverter.rssToMediaList(feed: rssFeed!);
                                  await _audioHandler.updateQueue(list);
                                  _audioHandler.skipToQueueItem(index);
                                  if(!playing) _audioHandler.play();
                                }
                                else {
                                  if(playbackState?.queueIndex!=index){
                                    await _audioHandler.skipToQueueItem(index);
                                    if(!playing) _audioHandler.play();
                                    return;
                                  }
                                }
                              }
                            },
                          ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                        if(index==1||index==15){
                          return const FacebookNativeWidget();
                        }
                        else {
                          return const SizedBox.shrink();
                        }
                    },
                    ),
                  ],
                );
              }
            );
          }
      ),
        ),
        const MiniPlayerWidget()
      ],
    );
  }

}
