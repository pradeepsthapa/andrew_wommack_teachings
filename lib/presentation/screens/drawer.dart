import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/screens/favourites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = context.read(themeStateProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/drawer.jpg'),fit: BoxFit.cover)
            ),
            accountName: Text('Andrew Wommack Audio Teachings'),
            accountEmail: Text('pradeepsthapa@gmail.com',style: TextStyle(fontSize: 12,color: Colors.grey[500]),),),
          ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.palette_rounded),
            title: Text("Color",style: TextStyle(fontSize: 14),),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 12),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: theme.swatchColors.map((e) =>
                        InkWell(
                          borderRadius: BorderRadius.circular(5),
                          splashFactory: InkRipple.splashFactory,
                          onTap: ()=>theme.changeColor(colorIndex: theme.swatchColors.indexOf(e)),
                          child: Container(
                            padding: EdgeInsets.all(1),
                            height: 30,width: 30,
                            decoration:BoxDecoration(borderRadius: BorderRadius.circular(100),
                                border: theme.currentColor==theme.swatchColors.indexOf(e)?Border.all(width: 2,color: e):null),
                            child: CircleAvatar(backgroundColor: e, radius: 15,),),
                        )).toList()),
              )],
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.favorite_border_rounded),
            title: Text("Favourites"),
            onTap: (){
              Scaffold.of(context).openEndDrawer();
              Navigator.push(context, PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 300),
                  transitionsBuilder: (context,a1,a2,child){
                    return ScaleTransition(
                        alignment: Alignment.bottomCenter,
                        scale: a1,
                      child: child,
                    );
                  },
                  pageBuilder: (context,  a1, a2) {
                return FavouritesScreen();
              }));
            },
          ),

          ListTile(leading: Icon(Icons.share),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text("Share"),
            onTap: ()=>share(context),
          ),
          ListTile(leading: Icon(Icons.person_add_alt),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text('About App'),
            onTap: (){
             customDialog(context);
            },
          ),

          ListTile(
            dense: true,
            leading: Icon(Icons.apps),
            title: Text("More Apps"),
            onTap: ()async{
              const url = 'https://play.google.com/store/apps/developer?id=pTech';
              if(await canLaunch(url)){
                await launch(url);
              }
              else{
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(leading: Icon(Icons.login_rounded),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text("Exit"),
            onTap: ()=>SystemNavigator.pop(),
          ),
        ],

      ),
    );
  }

  void customDialog(BuildContext context) {
    showGeneralDialog(context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black45,
        transitionDuration: Duration(milliseconds: 240),
        pageBuilder: (context,a1,a2){
          return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("This application contain collection of Andrew Wommack's teachings. For more information or feedback please contact me below."),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text('pradeepsthapa@gmail.com',style: TextStyle(color: Colors.grey[500],fontSize: 15),),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Close")),
            ],
          );
        });
  }
    void share(BuildContext context) {
      final String text = 'https://play.google.com/store/apps/details?id=com.ccbc.andrew_wommack';
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      Share.share(text,sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
    }
}
