import 'package:andrew_wommack/data/custom_media_model.dart';
import 'package:andrew_wommack/logic/storage_controller.dart';
import 'package:andrew_wommack/logic/yt_services.dart';
import 'package:andrew_wommack/logic/favourites_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'feed_controller.dart';
import 'feed_repository.dart';
import 'interstitial_adservice.dart';

final fontSizeProvider = StateProvider<double>((ref)=>18.0);
final appColorProvider = StateProvider<int>((ref)=>4);
final globalFontProvider = StateProvider<int>((ref)=>0);

final feedRepositoryProvider = Provider<FeedRepository>((ref)=>FeedRepository());

final feedControllerProvider = StateNotifierProvider<FeedController,FeedState>((ref)=> FeedController(ref.watch(feedRepositoryProvider),));

final boxStorageProvider = ChangeNotifierProvider<StorageProvider>((ref)=>StorageProvider(ref.read)..initStorage());

final ytPlaylistProvider = FutureProvider<List<Video>>((ref)=>YTServices.geGospelTruthPlaylist());

final favouritesProvider = StateNotifierProvider<BookmarksState,List<CustomMediaItem>>((ref)=>BookmarksState()..getBookmarks());

final adStateProvider = Provider<AdService>((ref)=>AdService());

