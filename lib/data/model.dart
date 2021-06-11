import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class TeachingModel extends Equatable{
  final int? id;
  final String? tTitle;
  final String? tUrl;
  final String? image;
  final String? description;
  TeachingModel({@required this.id, @required this.tTitle, @required this.tUrl,@required this.image, @required this.description});

  @override
  List<Object?> get props => [id,tTitle,tUrl,description];

  factory TeachingModel.fromMap(Map<String, dynamic> map) {
    return new TeachingModel(
      id: map['id'] as int?,
      tTitle: map['tTitle'] as String?,
      tUrl: map['tUrl'] as String?,
      description: map['description'] as String?,
      image: map['image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'tTitle': this.tTitle,
      'tUrl': this.tUrl,
      'image': this.image,
      'description': this.description,
    } as Map<String, dynamic>;
  }
}