import 'package:andrew_wommack/data/model.dart';
import 'package:andrew_wommack/logic/feed_controller.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:andrew_wommack/presentation/widgets/loading_shimmer.dart';
import 'package:andrew_wommack/presentation/widgets/mini_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_loaded_screen.dart';

class FeedDetails extends StatefulWidget {
  final TeachingModel model;
  FeedDetails(this.model);

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read(feedControllerProvider.notifier).fetchFeed(widget.model.tUrl!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          elevation: 0,
          title: Text(widget.model.tTitle??'',style: TextStyle(color: Colors.white),),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Consumer(
            builder: (context, watch, child) {
              final state = watch(feedControllerProvider);
              if (state is FeedInitial) {
                return Text("Loading...");
              } else if (state is FeedLoading) {
                return ShimmerList();
              } else if (state is FeedLoaded) {
                return FeedLoadedScreen(rssFeed: state.feed, teachingModel: widget.model,);
              } else if (state is FeedError) {
                return Center(child: Text(state.message,style: TextStyle(fontWeight: FontWeight.bold),));
              }
              return Center(child: Text('Unable to fetch data...',style: TextStyle(fontWeight: FontWeight.bold),));
            },
          ),
          MiniPlayerWidget()
        ],
      ),
      // bottomNavigationBar: MiniPlayerWidget(),
    );
  }
}

