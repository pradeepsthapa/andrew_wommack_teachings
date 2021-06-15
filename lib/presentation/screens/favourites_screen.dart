import 'package:andrew_wommack/data/model.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_details.dart';

class FavouritesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(centerTitle: true,
          title: Text("Favourites",style: TextStyle(color: Colors.white),),elevation: 0,),
      ),
      body: Consumer(builder: (context, watch, child) {
        final List<TeachingModel> favourites = watch(favouriteAudioProvider).favList;
        if(favourites.isEmpty) return Center(child: Text("No Favourites yet",
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),));
        return ListView.builder(
          itemCount: favourites.length,
          itemBuilder: (context, index) {
            return Consumer(
              builder: (context, watch, child) {
                final item = favourites[index];
                return Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(item)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        children: [
                          Container(
                              height: 70,width: 70,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.black38,offset: Offset(-5,5),blurRadius: 3),
                                  ]
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset('assets/images/andrew_wommack.png'),
                                    imageUrl: item.image??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
                                    errorWidget: (context, url, error) => Image.network('https://www.podchaser.com/images/missing-image.png'),
                                  ),
                              ),
                          ),
                          Flexible(
                            child: ListTile(
                              title: Column(
                                mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.tTitle??'Andrew Wommack',style: TextStyle(fontWeight: FontWeight.w700),),
                                  Text(item.description??'',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12),maxLines: 3,overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(item.description??'',maxLines: 3,),
                              ),
                              trailing: IconButton(icon: Icon(Icons.favorite),onPressed: ()=>context.read(favouriteAudioProvider).toggleFavourite(item.tUrl!),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },),
    );
  }
}
