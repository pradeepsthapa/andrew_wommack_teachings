import 'package:equatable/equatable.dart';

class CustomMediaItem extends Equatable{
final String id;
final String artist;
final String album;
final String genre;
final String duration;
final String artUri;
final String title;
final Map<String,dynamic> extras;
const CustomMediaItem(
    {required this.id,
      required this.artist,
      required this.album,
      required this.genre,
      required this.duration,
      required this.artUri,
      required this.title,
      required this.extras});

  @override
  List<Object?> get props => [id,genre,album];

Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artist': artist,
      'album': album,
      'genre': genre,
      'duration': duration,
      'artUri': artUri,
      'extras': extras,
      'title':title,
    };
  }

  factory CustomMediaItem.fromMap(Map<String, dynamic> map) {
    return CustomMediaItem(
      id: map['id'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      genre: map['genre'] as String,
      duration: map['duration'] as String,
      artUri: map['artUri'] as String,
      extras: map['extras'] as Map<String,dynamic>,
      title: map['title'] as String
    );
  }
}