import 'package:andrew_wommack/audio/audio_task.dart';
import 'package:andrew_wommack/logic/media_converter.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/widgets/facebook_native_widget.dart';
import 'package:andrew_wommack/presentation/widgets/mini_player_widget.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  static final _audioHandler = GetIt.I.get<AudioPlayerHandler>();

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final bookmarks = ref.watch(favouritesProvider);

    return WillPopScope(
      onWillPop: () async{
        ref.read(adStateProvider).showMainAds();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: const Text("Favourites"),
            )),
        body: bookmarks.isEmpty?Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🎵",style: TextStyle(fontSize: 40),),
            const SizedBox(height: 10),
            Text("You have no favourites yet",style: TextStyle(color: Colors.grey[500],fontSize: 24),textAlign: TextAlign.center),
          ],
        ),):ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: bookmarks.length,
            itemBuilder: (context,index){
              final media = bookmarks[index];
              return StreamBuilder<MediaItem?>(
                stream: _audioHandler.mediaItem,
                builder: (context, mediaSnapshot) {
                  if(mediaSnapshot.hasError||mediaSnapshot.connectionState==ConnectionState.waiting||!mediaSnapshot.hasData){
                    return const SizedBox.shrink();
                  }
                  final data = mediaSnapshot.data;
                  return StreamBuilder<PlaybackState>(
                    stream: _audioHandler.playbackState,
                    builder: (context, playbackSnapshot) {
                      final playbackState = playbackSnapshot.data;
                      final playing = playbackState?.playing ?? false;
                      return Card(
                        shadowColor: Colors.black38,
                        child: ListTile(
                          selected: data?.id==media.id,
                          onTap: ()async{
                            final mediaItem = MediaConverter.customMediaItemToMediaItem(customMediaItem: media);
                            await _audioHandler.addQueueItem(mediaItem);
                            final list = _audioHandler.queue.value;
                            final queueIndex = list.indexOf(mediaItem);
                            await _audioHandler.skipToQueueItem(queueIndex);
                            if(!playing) _audioHandler.play();
                          },
                          contentPadding: EdgeInsets.zero,
                          title: Text(media.title),
                          subtitle: Text(media.genre),
                          trailing: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: IconButton(
                              onPressed: (){
                                ref.read(favouritesProvider.notifier).removeBookmark(customMediaItem: media);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Theme.of(context).primaryColorDark,
                                      content: const Text("Media removed from favourites"),duration: const Duration(seconds: 1),));
                              },
                              icon: Icon(Icons.delete_forever,color: Colors.red.withOpacity(0.7)),
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }
              );
            }),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            MiniPlayerWidget(),
            FacebookNativeWidget()
          ],
        ),
      ),
    );
  }
}
