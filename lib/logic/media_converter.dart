import 'package:andrew_wommack/data/custom_media_model.dart';
import 'package:audio_service/audio_service.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class MediaConverter{

  static List<MediaItem> rssToMediaList({required RssFeed feed}){
    final List<MediaItem> mediaList = feed.items?.map((e) => MediaItem(
      id: e.enclosure?.url??'',
      artist: e.itunes?.author??'',
      album: e.itunes?.subtitle??'',
      genre: e.description??'',
      duration: e.itunes?.duration??Duration.zero,
      artUri: Uri.parse(feed.image?.url??''),
      extras: {'date': e.pubDate.toString()
      },
      title: e.title??'',)).toList()??[];
    return mediaList;
  }

  static MediaItem rssToMedia({required RssItem rssItem, required RssFeed feed}){
    final media = MediaItem(
      id: rssItem.enclosure?.url??'',
      artist: rssItem.itunes?.author??'',
      album: rssItem.itunes?.subtitle??'',
      genre: rssItem.description??'',
      duration: rssItem.itunes?.duration??Duration.zero,
      artUri: Uri.parse(feed.image?.url??''),
      extras: {'date': rssItem.pubDate.toString()
      },
      title: rssItem.title??'',);
    return media;
  }

  static CustomMediaItem rssToCustomMediaItem({required RssItem rssItem, required RssFeed feed}){
    final media = CustomMediaItem(
      id: rssItem.enclosure?.url??'',
      artist: rssItem.itunes?.author??'',
      album: rssItem.itunes?.subtitle??'',
      genre: rssItem.description??'',
      duration: rssItem.itunes?.duration.toString()??'',
      artUri: feed.image?.url??'',
      extras: {'date': rssItem.pubDate.toString()
      },
      title: rssItem.title??'',);
    return media;
  }

  static MediaItem customMediaItemToMediaItem ({required CustomMediaItem customMediaItem}){
    final media = MediaItem(
      id: customMediaItem.id,
      artist: customMediaItem.artist,
      album: customMediaItem.album,
      genre: customMediaItem.genre,
      duration: _parseDuration(customMediaItem.duration),
      artUri: Uri.parse(customMediaItem.artUri),
      extras: customMediaItem.extras,
      title: customMediaItem.title,);
    return media;
  }



  static Duration _parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}