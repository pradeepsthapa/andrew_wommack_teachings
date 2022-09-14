
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTServices{

  static final YoutubeExplode _yt = YoutubeExplode();

  static const _gospelTruthPlaylist = "https://www.youtube.com/watch?v=IiI_yfDmgyM&list=PLOER0yhdOW6DyPJ71_QI2RmSXqkAnOvFH&ab_channel=AndrewWommack";
  static const _truthAndLiberty = "https://www.youtube.com/watch?v=J7QhW7Qje3s&list=PLOER0yhdOW6BQ_uBF9Kfkd-VvXe6zuPa7&ab_channel=AndrewWommack";
  static const _healingJourneys = "https://www.youtube.com/watch?v=oxfjDJFiDBw&list=PLOER0yhdOW6DZpBV0c_IHqLK6O-io2OVO&ab_channel=AndrewWommack";
  static const _popularUploads = "https://www.youtube.com/watch?v=b5aAGTNWNBA&list=PU8H3lzJU5Qm-s3WVroB87kw&ab_channel=AndrewWommack";

  static Future<List<Video>> geGospelTruthPlaylist() async {
    final List<Video> results = await _yt.playlists.getVideos(_gospelTruthPlaylist).take(100).toList();
    return results;
  }

  // static Future<Playlist> getPlaylistDetails() async {
  //   final Playlist metadata = await _yt.playlists.get(_playListUrl);
  //   return metadata;
  // }
}
