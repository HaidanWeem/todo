import 'dart:convert';

import 'package:equatable/equatable.dart';

Tasks taskFromJson(String str) {
  final jsonData = json.decode(str);
  return Tasks.fromJson(jsonData);
}

String taskToJson(Tasks data) {
  final res = data.toJson();
  return json.encode(res);
}

class Tasks extends Equatable {
  final int id;
  final String title;
  final String details;
  final bool checked;

  const Tasks(
      {required this.id,
      required this.title,
      required this.details,
      required this.checked});

  @override
  List<Object?> get props => [id, title, details, checked];

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        id: json['id'],
        title: json['title'],
        details: json['details'],
        checked: json['checked'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "checked": checked,
      };
}
