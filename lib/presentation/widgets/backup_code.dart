// import 'package:andrew_wommack/data/teaching_model.dart';
// import 'package:andrew_wommack/data/teaching_data.dart';
// import 'package:andrew_wommack/presentation/screens/feed_details.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:facebook_audience_network/ad/ad_native.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//
// class FeedCategory extends StatelessWidget {
//
//   final List<TeachingModel> allCategory = TeachingCategory.allList;
//
//   @override
//   Widget build(BuildContext context) {
//     return StaggeredGridView.countBuilder(
//       crossAxisCount: 4,
//       itemCount: allCategory.length,
//       itemBuilder: (BuildContext context, int index) {
//         if(index==0)
//           return Container();
//
//         // {
//         //   // return FacebookNativeAd(
//         //   //   placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650",
//         //   //   adType: NativeAdType.NATIVE_AD_VERTICAL,
//         //   //   width: double.infinity,
//         //   //   backgroundColor: Colors.blue,
//         //   //   titleColor: Colors.white,
//         //   //   descriptionColor: Colors.white,
//         //   //   buttonColor: Colors.deepPurple,
//         //   //   buttonTitleColor: Colors.white,
//         //   //   buttonBorderColor: Colors.white,
//         //   //   listener: (result, value) {
//         //   //     print("Native Ad: $result --> $value");
//         //   //   },
//         //   //   keepExpandedWhileLoading: true,
//         //   //   expandAnimationDuraion: 1000,
//         //   // );
//         // }
//         final item = allCategory[index];
//         return Card(
//           margin: EdgeInsets.zero,
//           elevation: 5,
//           shadowColor: Colors.black45,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(5),
//             splashFactory: InkRipple.splashFactory,
//             onTap: (){
//               // Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(item)));
//               Navigator.push(context, PageRouteBuilder(
//                   transitionDuration: Duration(milliseconds: 700),
//                   transitionsBuilder: (context,a1,a2,child){
//                     return FadeTransition(
//                       opacity: a1,
//                       child: child,
//                     );
//                   },
//                   pageBuilder: (context,  a1, a2) {
//                     return FeedDetails(item);
//                   }));
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(7.0),
//               child: Column(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
//                     child: CachedNetworkImage(fit: BoxFit.cover,height: 170,
//                       placeholder: (context, url) => Image.asset('assets/images/andrew_wommack.png'),
//                       imageUrl: item.image??'https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg',
//                       errorWidget: (context, url, error) => Image.network('https://believersportal.com/wp-content/uploads/2016/09/andrew-wommack.jpg'),
//                     ),
//                   ),
//                   Center(child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
//                     child: Text(item.tTitle??'',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
//                   )),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
//                     child: Text(item.description??'',style: TextStyle(fontSize: 12,),maxLines: 7,overflow: TextOverflow.ellipsis,),
//                   ),
//                 ],),
//             ),
//           ),
//         );
//       },
//       staggeredTileBuilder: (int index) {
//         return StaggeredTile.fit(2);
//       },
//       mainAxisSpacing: 7.0,
//       crossAxisSpacing: 7.0,
//     );
//   }
// }