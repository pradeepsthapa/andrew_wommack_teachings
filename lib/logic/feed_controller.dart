import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'feed_repository.dart';

abstract class FeedState{
  const FeedState();
}

class FeedInitial extends FeedState{
  const FeedInitial();
}

class FeedLoading extends FeedState{
  const FeedLoading();
}

class FeedLoaded extends FeedState{
  final RssFeed feed;
  const FeedLoaded(this.feed);

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return other is FeedLoaded && other.feed == feed;
  }

  @override
  int get hashCode => feed.hashCode;
}

class FeedError extends FeedState{
  final String message;
  FeedError(this.message);
  @override
  bool operator ==(Object other) {
    if(identical(this, other))  return true;
    return other is FeedError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class FeedController extends StateNotifier<FeedState>{
  FeedRepository feedRepository;
  FeedController(this.feedRepository) : super(FeedInitial());

  Future<void> fetchFeed(String feedUrl)async{
    try{
      state = FeedLoading();
      final feed = await feedRepository.getFeed(feedUrl: feedUrl);
      if(feed!=null) {
        state = FeedLoaded(feed);
      }
    }
    on Failure catch(e){
      state = FeedError("Unable to fetch data. Are you connected to the internet ?");
    }
  }
}