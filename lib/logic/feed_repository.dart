import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

abstract class BaseFeedRepository{
  Future<RssFeed?> getFeed({String feedUrl});
}

class FeedRepository extends BaseFeedRepository{

  @override
  Future<RssFeed?> getFeed({@required String? feedUrl}) async{
    try{
      final response = await http.read(Uri.parse(feedUrl!));
      if(response.isNotEmpty){
        return RssFeed.parse(response);
      }
    }on SocketException catch(e){
      throw Failure(message: e.message);
    }on HttpException catch (e){
      throw Failure(message: e.message);
    }on Exception catch(e){
      throw Failure(message: "Something went wrong \n$e");
    }
    return null;
  }
}

class Failure implements Exception{
  final String message;
  const Failure({this.message='Something went wrong'});

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return other is Failure && other.message == message;
  }
  @override
  int get hashCode => message.hashCode;
}