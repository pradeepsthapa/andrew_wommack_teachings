import 'package:andrew_wommack/logic/audio_favourites.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_controller.dart';
import 'feed_repository.dart';
import 'theme_state.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref)=>FeedRepository());

final feedControllerProvider = StateNotifierProvider<FeedController,FeedState>((ref){
  return FeedController(ref.watch(feedRepositoryProvider),);
});

final themeStateProvider = ChangeNotifierProvider<MainTheme>((ref)=>MainTheme());

final favouriteAudioProvider = ChangeNotifierProvider<AudioFavourites>((ref)=>AudioFavourites());