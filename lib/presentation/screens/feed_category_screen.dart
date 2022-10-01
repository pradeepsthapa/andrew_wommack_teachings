import 'package:andrew_wommack/data/teaching_model.dart';
import 'package:andrew_wommack/data/teaching_data.dart';
import 'package:andrew_wommack/presentation/screens/feed_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class FeedCategory extends StatelessWidget {
  const FeedCategory({Key? key}) : super(key: key);

  static final List<TeachingModel> _allCategory = TeachingCategory.allList;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: _allCategory.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _allCategory[index];
        return Card(
          margin: EdgeInsets.zero,
          elevation: 5,
          shadowColor: Colors.black45,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            splashFactory: InkRipple.splashFactory,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(item)));
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                      child: CachedNetworkImage(fit: BoxFit.cover,height: 170,
                        placeholder: (context, url) => Image.asset('assets/images/andrew_wommack.png'),
                        imageUrl: item.image,
                        errorWidget: (context, url, error) => Image.network('https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg'),
                      ),
                  ),
                  Center(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                    child: Text(item.tTitle,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    child: Text(item.description,style: const TextStyle(fontSize: 12,),),
                  ),
                ],),
            ),
          ),
        );
      },
      mainAxisSpacing: 7.0,
      crossAxisSpacing: 7.0,
    );
  }
}