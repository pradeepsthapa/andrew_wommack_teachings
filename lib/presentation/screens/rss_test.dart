// import 'package:flutter/material.dart';
// import 'package:webfeed/webfeed.dart';
// import 'package:http/http.dart' as http;
// class RssTest extends StatefulWidget {
//   const RssTest({Key? key}) : super(key: key);
//
//
//   @override
//   _RssTestState createState() => _RssTestState();
// }
//
// class _RssTestState extends State<RssTest> {
//
//   // RegExp(r"<[^>]*>" // remove HTML tags
//
//   // static const String FEED_URL = 'http://calvarychapelcornerstone.cloversites.com/podcast/12ae807a-f7cb-43de-a9c3-c1a11db60c2e.xml';
//   static const String FEED_URL =
//       'http://feeds.feedburner.com/awm_1052'
//   ;
//   // static const String FEED_URL = 'http://feeds.feedburner.com/JosephPrinceAudioPodcast';
//   RssFeed? _feed;
//
//
//   Future<RssFeed?> loadFeed() async {
//     try {
//       final client = http.Client();
//       final response = await client.get(Uri.parse(FEED_URL));
//       return RssFeed.parse(response.body);
//     } catch (e) {
//       //
//     }
//     return null;
//   }
//
//
//
//   updateFeed(RssFeed? feed) {
//     setState(() {
//       _feed = feed;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadFeed().then((value) => updateFeed(value));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//           itemCount: _feed?.items?.length??0,
//           itemBuilder: (context,index){
//             final item = _feed?.items?[index];
//             return ListTile(
//               title: Text(item?.title??"Loading..."),
//               subtitle: Text(item?.title?.replaceAll(RegExp(r"<[^>]*>"), '')??'descrition loading...'),
//               onTap: (){
//                 print(item?.enclosure?.url);
//                 print(item?.enclosure?.length);
//               },
//             );
//           }),);
//   }}
//
