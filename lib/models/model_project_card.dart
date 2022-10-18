import 'dart:convert';

import 'package:flutter/foundation.dart';

class ModelProjectCard {
  String title = '';
  String projectIcon = '';
  String smallDescription = '';
  String fullDescription = '';
  List<String> listOfImages = [];
  ModelProjectCard({
    required this.title,
    required this.projectIcon,
    required this.smallDescription,
    required this.fullDescription,
    required this.listOfImages,
  });

  ModelProjectCard copyWith({
    String? title,
    String? projectIcon,
    String? smallDescription,
    String? fullDescription,
    List<String>? listOfImages,
  }) {
    return ModelProjectCard(
      title: title ?? this.title,
      projectIcon: projectIcon ?? this.projectIcon,
      smallDescription: smallDescription ?? this.smallDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      listOfImages: listOfImages ?? this.listOfImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'projectIcon': projectIcon,
      'smallDescription': smallDescription,
      'fullDescription': fullDescription,
      'listOfImages': listOfImages,
    };
  }

  factory ModelProjectCard.fromMap(Map<String, dynamic> map) {
    return ModelProjectCard(
      title: map['title'] ?? '',
      projectIcon: map['projectIcon'] ?? '',
      smallDescription: map['smallDescription'] ?? '',
      fullDescription: map['fullDescription'] ?? '',
      listOfImages: List<String>.from(map['listOfImages']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelProjectCard.fromJson(String source) => ModelProjectCard.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ModelProjectCard(title: $title, projectIcon: $projectIcon, smallDescription: $smallDescription, fullDescription: $fullDescription, listOfImages: $listOfImages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModelProjectCard &&
        other.title == title &&
        other.projectIcon == projectIcon &&
        other.smallDescription == smallDescription &&
        other.fullDescription == fullDescription &&
        listEquals(other.listOfImages, listOfImages);
  }

  @override
  int get hashCode {
    return title.hashCode ^ projectIcon.hashCode ^ smallDescription.hashCode ^ fullDescription.hashCode ^ listOfImages.hashCode;
  }
}
