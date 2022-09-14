import 'package:andrew_wommack/data/constants.dart';
import 'package:andrew_wommack/data/font_model.dart';
import 'package:andrew_wommack/data/teaching_model.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/screens/yt_videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'favourites_screen.dart';
import 'feed_details.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  final TeachingModel _charisDailyBibleStudy =  const TeachingModel(
    id: 1,
    tTitle: 'Charis Daily Live Bible Study',
    tUrl: 'https://www.spreaker.com/show/4166898/episodes/feed',
    description: '''Join Andrew Wommack and special guests every weekday for our Charis Daily Live Bible Study! Interact with dynamic speakers in real-time and gain a deeper understanding of the scriptures as they answer your questions. Tune in every day to hear from different speakers as they share from God's Word. The instructors will not only include Andrew Wommack and Charis Woodland Park staff but also our stateside and international directors. You'll witness miracles happen right there, wherever you're listening!''',
    image: 'http://s3.awmi.net/podcasts/images/teaching/awm_1044.jpg',);
  final TeachingModel _gospelTruthAudios =  const TeachingModel(
    id: 2,
    tTitle: 'The Gospel Truth',
    tUrl: 'https://www.spreaker.com/show/3271115/episodes/feed',
    description: '''This podcast features the daily Gospel Truth TV broadcasts from Andrew Wommack Ministries.''',
    image: 'http://s3.awmi.net/podcasts/images/teaching/awm_1044.jpg',);

  final TeachingModel _recordedLive =  const TeachingModel(
    id: 3,
    tTitle: 'Andrew Wommack Recorded Live',
    tUrl: 'https://www.spreaker.com/show/3271110/episodes/feed',
    description: '''Enjoy Andrew's teachings on the go with the new Andrew Wommack Recorded Live podcasts (formerly Gospel Truth Radio podcasts). You can now look forward to weekly, hour-long podcasts instead of fifteen-minute segments on weekdays. Taken from past Gospel Truth Conferences and other live events, you'll enjoy Andrew's humor and personality—in ways that you might not typically experience them on his studio broadcasts—while building yourself up in the Word. Subscribe to have your library of grace-based teachings automatically updated as they become available—tune in to the Word today!''',
    image: 'http://s3.awmi.net/podcasts/images/teaching/awm_1044.jpg',);

  final TeachingModel _conferences =  const TeachingModel(
    id: 4,
    tTitle: 'Andrew Wommack Conferences',
    tUrl: 'http://feeds.feedburner.com/AndrewWommackConferences',
    description: '''Andrew Wommack Conferences''',
    image: 'http://s3.awmi.net/podcasts/images/teaching/awm_1044.jpg',);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/drawer.jpg'),fit: BoxFit.cover)
            ),
            accountName: const Text('Andrew Wommack Audio Teachings'),
            accountEmail: Text('pradeepsthapa@gmail.com',style: TextStyle(fontSize: 12,color: Colors.grey[500]),),),
          ExpansionTile(
            initiallyExpanded: true,
            leading: const Icon(Icons.palette_rounded),
            title: const Text("Color",style: TextStyle(fontSize: 14),),
            children: [
              SizedBox(height: 40,
                child: Consumer(
                  builder: (context,ref, child) {
                    final colorIndex = ref.watch(appColorProvider);
                    return ListView(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: Colors.primaries.map((e) =>
                            InkWell(
                              borderRadius: BorderRadius.circular(5),
                              splashFactory: InkRipple.splashFactory,
                              onTap: () {
                                ref.read(boxStorageProvider).saveBackground(Colors.primaries.indexOf(e));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(1.5),
                                height: 33,width: 33,
                                decoration:BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: colorIndex==Colors.primaries.indexOf(e)?Border.all(width: 1.5,color: e):null),
                                child: CircleAvatar(backgroundColor: e),),
                            )).toList());
                  }
                ),
              )],
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.favorite_border_rounded),
            title: const Text("Favourites"),
            onTap: (){
              Scaffold.of(context).openEndDrawer();
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const BookmarkScreen()));
            },
          ),

          ListTile(leading: const Icon(Icons.video_call),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("Gospel Truth Videos"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const VideosScreen()));
            },
          ),
          // ListTile(leading: const Icon(Icons.queue_music),
          //   dense: true,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          //   title: const Text("Gospel Truth Audios"),
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(_gospelTruthAudios)));
          //   },
          // ),
          ListTile(leading: const Icon(Icons.queue_music),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("Recorded Live"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(_recordedLive)));
            },
          ),
          ListTile(leading: const Icon(Icons.queue_music),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("Conferences"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(_conferences)));
            },
          ),
          const Divider(height: 0,thickness: 1),

          ListTile(leading: const Icon(Icons.share),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("Share"),
            onTap: ()=>share(context),
          ),
          ListTile(leading: const Icon(Icons.font_download_outlined),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("Primary Font"),
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                pageBuilder: (context, anim1, anim2) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: ()=>Navigator.pop(context),
                          child: const Text("Cancel")),
                    ],
                    contentPadding: EdgeInsets.zero,
                    scrollable: true,
                    title: Text("Select Font",style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                    content: SingleChildScrollView(
                      child: Consumer(
                          builder: (context,ref, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: Constants.globalFonts.map((e) => RadioListTile<GlobalFontModel>(
                                dense: true,
                                title: Text(e.fontName??'',style: TextStyle(fontFamily: e.fontFamily),),
                                groupValue: Constants.globalFonts[ref.watch(globalFontProvider)],
                                value: e,
                                onChanged: (value){
                                  final fontIndex = Constants.globalFonts.indexOf(value!);
                                  ref.read(boxStorageProvider).saveFontStyle(fontIndex);
                                  Navigator.pop(context);
                                },
                              )).toList(),
                            );
                          }
                      ),
                    ),
                  );
                },);
            },
          ),
          ListTile(leading: const Icon(Icons.person_add_alt),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('About App'),
            onTap: (){
             customDialog(context);
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.apps),
            title: const Text("More Apps"),
            onTap: ()async{
              const url = 'https://play.google.com/store/apps/developer?id=pTech';
              if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $url';
            },
          ),
          ListTile(leading: const Icon(Icons.login_rounded),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("Exit"),
            onTap: ()=>SystemNavigator.pop(),
          ),
          const Divider(height: 0,thickness: 1),
        ],

      ),
    );
  }

  void customDialog(BuildContext context) {
    showGeneralDialog(context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 240),
        pageBuilder: (context,a1,a2){
          return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("This application contain collection of Andrew Wommack's teachings. For more information or feedback please contact me below."),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text('pradeepsthapa@gmail.com',style: TextStyle(color: Colors.grey[500],fontSize: 15),),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Close")),
            ],
          );
        });
  }
    void share(BuildContext context) {
      const String text = 'https://play.google.com/store/apps/details?id=com.ccbc.andrew_wommack';
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      Share.share(text,sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
    }
}


// https://calvaryposts.com/andrew-wommack-audio-teachings/