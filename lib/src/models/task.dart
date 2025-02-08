import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String status, // 例: "Inbox", "Next Action", "Waiting", "Completed"
    DateTime? dueDate,
    String? priority, // 例: "あか", "はいいろ" など、カラーコード名
    String? description,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
