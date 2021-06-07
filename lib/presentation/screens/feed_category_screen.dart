import 'package:andrew_wommack/data/model.dart';
import 'package:andrew_wommack/data/model_data.dart';
import 'package:andrew_wommack/presentation/screens/feed_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FeedCategory extends StatelessWidget {

  final List<TeachingModel> allCategory = TeachingCategory.allList;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: allCategory.length,
      itemBuilder: (BuildContext context, int index) {
        final item = allCategory[index];
        return Card(
          margin: EdgeInsets.zero,
          elevation: 5,
          shadowColor: Colors.black45,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(item)));
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                      child: FadeInImage(fit: BoxFit.cover,
                        placeholder: AssetImage('assets/images/drawer.jpg'),
                        image: NetworkImage('https://cachedimages.podchaser.com/512x512/aHR0cHM6Ly9kM3Qzb3pmdG1kbWgzaS5jbG91ZGZyb250Lm5ldC9wcm9kdWN0aW9uL3BvZGNhc3RfdXBsb2FkZWRfbm9sb2dvLzExODE5Njc5LzExODE5Njc5LTE2MTAxMTcxNjY1MzAtM2NlZDU4ZWIxZjFiMi5qcGc%3D/aHR0cHM6Ly93d3cucG9kY2hhc2VyLmNvbS9pbWFnZXMvbWlzc2luZy1pbWFnZS5wbmc%3D',),
                      ),
                  ),
                  Center(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                    child: Text(item.tTitle??'',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    child: Text(item.description??'',style: TextStyle(fontSize: 12,),maxLines: 7,overflow: TextOverflow.ellipsis,),
                  ),
                ],),
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(2);
      },
      mainAxisSpacing: 7.0,
      crossAxisSpacing: 7.0,
    );
  }
}