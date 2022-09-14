import 'package:audio_service/audio_service.dart';

class MediaLibrary {
  static const albumsRootId = 'albums';

  final items = <String, List<MediaItem>>{
    AudioService.browsableRootId: const [
      MediaItem(
        id: albumsRootId,
        title: "default",
        playable: false,
      ),
    ],
    albumsRootId: const [
      MediaItem(
        id: 'https://raw.githubusercontent.com/anars/blank-audio/master/1-second-of-silence.mp3',
        album: "Test Album",
        title: "Test Title",
        artist: "",
      ),
    ],
  };
}