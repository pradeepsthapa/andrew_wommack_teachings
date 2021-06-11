import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/screens/feed_category_screen.dart';
import 'package:andrew_wommack/presentation/screens/mini_player.dart';
import 'package:audio_service/audio_service.dart';
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
      // themeMode: theme.platformBrightness==Brightness.dark?ThemeMode.dark:theme.toggleThemeMode(theme.isDark),
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        primarySwatch: theme.swatchColor,
        scaffoldBackgroundColor: Colors.grey[200]
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
            IconButton(
                onPressed: ()=>context.read(themeStateProvider).toggleDarkMode(),
                icon: Icon(isDark?Icons.brightness_4:Icons.brightness_2))
          ],
        ),
      ),
      drawer: MainDrawer(),
      body: FeedCategory(),
      bottomNavigationBar: MiniPlayer(),
    );
  }
}

