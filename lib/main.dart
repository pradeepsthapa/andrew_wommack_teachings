import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/screens/feed_category_screen.dart';
import 'package:andrew_wommack/presentation/widgets/mini_player_widget.dart';
import 'package:andrew_wommack/presentation/widgets/search_bar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/screens/drawer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await FlutterDownloader.initialize(debug: true);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(context, watch) {
    final theme = watch(themeStateProvider);
    return MaterialApp(
      themeMode: theme.isDark?ThemeMode.dark:ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(textTheme: GoogleFonts.varelaRoundTextTheme()),
        textTheme: GoogleFonts.varelaRoundTextTheme().copyWith(
            bodyText2: TextStyle(color: Colors.white,fontFamily: GoogleFonts.varelaRound().fontFamily),
            bodyText1: TextStyle(color: Colors.white,fontFamily: GoogleFonts.varelaRound().fontFamily),
            subtitle1:  TextStyle(color: Colors.white,fontFamily: GoogleFonts.varelaRound().fontFamily),
            caption:TextStyle(color: Colors.white,),

        ),
      ),
      theme: ThemeData(
        appBarTheme: AppBarTheme(textTheme: GoogleFonts.varelaRoundTextTheme()),
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        textTheme: GoogleFonts.varelaRoundTextTheme(),
        primarySwatch: theme.swatchColor,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: AudioServiceWidget(child: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness==Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text("Andrew Wommack Teachings",style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(onPressed: (){
              showSearch(context: context, delegate: SearchBar());
            }, icon: Icon(EvaIcons.search)),
            IconButton(
                onPressed: ()=>context.read(themeStateProvider).toggleDarkMode(),
                icon: Icon(isDark?Icons.brightness_4:EvaIcons.sun))
          ],
        ),
      ),
      drawer: MainDrawer(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          FeedCategory(),
          MiniPlayerWidget()
        ],
      ),
      // bottomNavigationBar: MiniPlayer(),
    );
  }
}

