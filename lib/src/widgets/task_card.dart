// lib/src/widgets/task_card.dart
import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text('Status: ${task.status}'),
        trailing: Text(task.priority ?? ''),
        onTap: () {
          // タスク詳細画面への遷移（必要に応じて実装）
        },
      ),
    );
  }
}
