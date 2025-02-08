import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../services/notion_api_service.dart';

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier(ref);
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final Ref ref;

  TaskListNotifier(this.ref) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final tasks = await ref.read(notionApiServiceProvider).fetchTasks();
      state = tasks;
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> addTask(Task newTask) async {
    try {
      await ref.read(notionApiServiceProvider).createTask(newTask);
      await loadTasks();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      await ref.read(notionApiServiceProvider).updateTask(updatedTask);
      await loadTasks();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await ref.read(notionApiServiceProvider).deleteTask(taskId);
      await loadTasks();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
