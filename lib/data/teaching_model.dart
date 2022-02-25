import 'package:equatable/equatable.dart';

class TeachingModel extends Equatable{
  final int id;
  final String tTitle;
  final String tUrl;
  final String image;
  final String description;
  const TeachingModel({required this.id, required this.tTitle, required this.tUrl,required this.image, required this.description});

  @override
  List<Object?> get props => [id,tTitle,tUrl,description];

  factory TeachingModel.fromMap(Map<String, dynamic> map) {
    return TeachingModel(
      id: map['id'] as int,
      tTitle: map['tTitle'] as String,
      tUrl: map['tUrl'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tTitle': tTitle,
      'tUrl': tUrl,
      'image': image,
      'description': description,
    };
  }
}