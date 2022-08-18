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
  final String text;
  final bool checked;

  const Tasks({required this.id, required this.text, required this.checked});

  @override
  List<Object?> get props => [id, text, checked];

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
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
