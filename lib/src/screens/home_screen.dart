// lib/src/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notion GTD Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(taskListProvider.notifier).loadTasks();
        },
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskCard(task: tasks[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // タスク追加画面への遷移（必要に応じて実装）
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
