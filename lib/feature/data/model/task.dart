import 'dart:convert';

import 'package:equatable/equatable.dart';

Task taskFromJson(String str) {
  final jsonData = json.decode(str);
  return Task.fromJson(jsonData);
}

String taskToJson(Task data) {
  final res = data.toJson();
  return json.encode(res);
}

class Task extends Equatable {
  final int id;
  final String text;
  final bool checked;

  const Task({required this.id, required this.text, required this.checked});

  @override
  List<Object?> get props => [id, text, checked];

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        text: json["task"],
        checked: json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task": text,
        "checked": checked,
      };
}
