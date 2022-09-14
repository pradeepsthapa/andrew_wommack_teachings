import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/screens/feed_category_screen.dart';
import 'package:andrew_wommack/presentation/widgets/mini_player_widget.dart';
import 'package:andrew_wommack/presentation/widgets/search_bar.dart';
import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'audio/audio_task.dart';
import 'data/constants.dart';
import 'presentation/screens/drawer.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'presentation/widgets/banner_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FacebookAudienceNetwork.init();
  await setupLocator();
  runApp(const ProviderScope(child: MyApp()));
}


Future<void> setupLocator()async{
  await GetStorage.init();
  GetIt.instance.registerSingleton<GetStorage>(GetStorage());
  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ccbc.andrew_wommack',
      androidNotificationChannelName: 'Andrew Wommack Teachings',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
  );
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final font = ref.watch(globalFontProvider);
    final globalFont = Constants.globalFonts[font];
    return MaterialApp(
      title: 'Andrew Wommack Teachings',
      themeMode: ref.watch(boxStorageProvider).isDark?ThemeMode.dark:ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          primaryTextTheme: globalFont.textTheme.copyWith(
            headline6: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
          ),
          textTheme: globalFont.textTheme.copyWith(
            overline: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            bodyText2: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            subtitle1: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            caption: TextStyle(
              color: Colors.white70,
              fontFamily: globalFont.fontFamily,
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.scaled),
          })),
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.primaries[ref.watch(appColorProvider)],
          fontFamily: globalFont.fontFamily,
          textTheme: globalFont.textTheme,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.scaled),
          })
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boxStorageProvider).loadInitials();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness==Brightness.dark;
    return WillPopScope(
      onWillPop: () async{
        ref.read(adStateProvider).showExitAd();
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColorDark,
            title: const Text("Andrew Wommack Teachings",style: TextStyle(color: Colors.white),),
            actions: [
              IconButton(onPressed: (){
                showSearch(context: context, delegate: SearchBar());
              }, icon: const Icon(EvaIcons.search,color: Colors.white,)),
              IconButton(
                  onPressed: () {
                    if(!isDark) {
                      ref.read(boxStorageProvider).changeDarkTheme(true);
                    } else {ref.read(boxStorageProvider).changeDarkTheme(false);}
                  },
                  icon: Icon(isDark?Icons.brightness_4:EvaIcons.sun,color: Colors.white,))
            ],
          ),
        ),
        drawer: const MainDrawer(),
        body: Stack(
          alignment: Alignment.center,
          children: const [
            FeedCategory(),
            MiniPlayerWidget()
          ],
        ),
        bottomNavigationBar: const BannerAdWidget(),
      ),
    );
  }
}

