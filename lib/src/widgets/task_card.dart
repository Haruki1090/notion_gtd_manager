import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/task_detail_screen.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Notion カラーをアクセントに使用（例：Priority に応じた色）
    Color accentColor;
    switch (task.priority) {
      case 'あか':
        accentColor = const Color(0xFFD44C47);
        break;
      case 'あお':
        accentColor = const Color(0xFF337EA9);
        break;
      case 'みどり':
        accentColor = const Color(0xFF448361);
        break;
      case 'きいろ':
        accentColor = const Color(0xFFCB912F);
        break;
      case 'おれんじ':
        accentColor = const Color(0xFFD9730D);
        break;
      case 'ちゃいろ':
        accentColor = const Color(0xFF9F6B53);
        break;
      case 'はいいろ':
        accentColor = const Color(0xFF787774);
        break;
      case 'むらさき':
        accentColor = const Color(0xFF9065B0);
        break;
      case 'ぴんく':
        accentColor = const Color(0xFFC14C8A);
        break;
      default:
        accentColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: accentColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            'Status: ${task.status}\nDue: ${task.dueDate != null ? task.dueDate!.toLocal().toString().split(' ')[0] : 'None'}'),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 編集画面へ遷移
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TaskDetailScreen(task: task)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // 完了にする（status を Completed に更新）
                ref.read(taskListProvider.notifier).completeTask(task);
              },
            ),
          ],
        ),
      ),
    );
  }
}
