class todo {
  String? id;
  String? text_todo;
  DateTime date_time;
  bool is_done;

  todo(
      {required this.id,
      required this.text_todo,
      required this.date_time,
      this.is_done = false});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text_todo': text_todo,
      'date_time': date_time.toIso8601String(),
      'is_done': is_done,
    };
  }

  factory todo.fromJson(Map<String, dynamic> json) {
    return todo(
      id: json['id'],
      text_todo: json['text_todo'],
      date_time: DateTime.parse(json['date_time']),
      is_done: json['is_done'],
    );
  }

  static List<todo> todo_list() {
    return [];
  }
}
