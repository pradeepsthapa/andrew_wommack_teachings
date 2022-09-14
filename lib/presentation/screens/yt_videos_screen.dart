import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/widgets/banner_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosScreen extends ConsumerWidget {
  const VideosScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async{
        ref.read(adStateProvider).showMainAds();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            title: const Text("Gospel Truth"),
          ),
        ),
        body: ref.watch(ytPlaylistProvider).when(
            data: (videos){
              return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context,index){
                    final video = videos[index];
                    return GestureDetector(
                      onTap: ()async{
                        final url = video.url;
                        if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                      },
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black38,
                        margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              imageUrl: video.thumbnails.standardResUrl,
                              placeholder: (context, url) => Image.asset("assets/images/placeholder.png",width: double.infinity,height: 200),
                              errorWidget: (_,__,___)=>Image.asset("assets/images/placeholder.png",width: double.infinity,height: 200),
                            ),
                            ListTile(
                              title: Text(video.title,style: const TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(video.author,),
                                  Text(video.duration.toString().split('.')[0].replaceFirst('0.0', ''),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            error: (error,st)=>Padding(padding: const EdgeInsets.all(8.0), child: Text(error.toString(),style: TextStyle(color: Theme.of(context).textTheme.caption?.color),),
            ),
            loading: ()=>const Center(child: CircularProgressIndicator(),)),
        bottomNavigationBar: const BannerAdWidget(),
      ),
    );
  }
}
