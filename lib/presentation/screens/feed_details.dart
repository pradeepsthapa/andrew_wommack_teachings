import 'package:andrew_wommack/data/teaching_model.dart';
import 'package:andrew_wommack/logic/feed_controller.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/widgets/banner_widget.dart';
import 'package:andrew_wommack/presentation/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_loaded_screen.dart';

class FeedDetails extends ConsumerStatefulWidget {
  final TeachingModel model;
  const FeedDetails(this.model, {Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends ConsumerState<FeedDetails> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedControllerProvider.notifier).fetchFeed(widget.model.tUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        ref.read(adStateProvider).showMainAds();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            elevation: 0,
            title: Text(widget.model.tTitle,style: const TextStyle(color: Colors.white),),
          ),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(feedControllerProvider);
            if (state is FeedInitial) {
              return const Text("Loading...");
            } else if (state is FeedLoading) {
              return const ShimmerList();
            } else if (state is FeedLoaded) {
              return FeedLoadedScreen(rssFeed: state.feed, teachingModel: widget.model,);
            } else if (state is FeedError) {
              return Center(child: Text(state.message,style: const TextStyle(fontWeight: FontWeight.bold),));
            }
            return const Center(child: Text('Unable to fetch data...',style: TextStyle(fontWeight: FontWeight.bold),));
          },
        ),
        bottomNavigationBar: const BannerAdWidget(),
      ),
    );
  }
}

