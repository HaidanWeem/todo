import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';


class Tasks extends Equatable {
  final int id;
  final String title;
  final String details;
  final bool checked;
  final Uint8List? image;

  const Tasks({
    required this.id,
    required this.title,
    required this.details,
    required this.checked,
    this.image,
  });

  @override
  List<Object?> get props => [id, title, details, checked];

  factory Tasks.fromJson(Map<String, dynamic> json, Uint8List? image) {

    return Tasks(
      id: json['id'],
      title: json['title'],
      details: json['details'],
      checked: json['checked'] == 1,
      image: image,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "checked": checked,
      };
}
