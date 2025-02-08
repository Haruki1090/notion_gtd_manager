// lib/src/services/notion_api_service.dart
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/task.dart';

final notionApiServiceProvider =
    Provider<NotionApiService>((ref) => NotionApiService());

class NotionApiService {
  String? _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  void clearAccessToken() {
    _accessToken = null;
  }

  Future<List<Task>> fetchTasks() async {
    if (_accessToken == null) throw Exception('Not authenticated with Notion');
    final databaseId = dotenv.env['NOTION_DATABASE_ID'];
    final url = 'https://api.notion.com/v1/databases/$databaseId/query';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Task> tasks = [];
      for (var result in data['results']) {
        // タイトルの取得：リストが空の場合は空文字を返す
        final List<dynamic>? titleList = result['properties']['Name']['title'];
        final String title = (titleList != null && titleList.isNotEmpty)
            ? (titleList.first['plain_text'] ?? '')
            : '';

        // ステータス：nullチェックを行う
        final String status =
            result['properties']['Status']['select']?['name'] ?? '';

        // 期限（文字列の場合、そのまま保持。後で DateTime に変換するなど）
        final String? dueDateString =
            result['properties']['Due Date']?['date']?['start'];
        final DateTime? dueDate =
            dueDateString != null ? DateTime.tryParse(dueDateString) : null;

        // 優先度：nullチェック
        final String priority =
            result['properties']['Priority']['select']?['name'] ?? '';

        // 説明：同様に空リストの場合は空文字を返す
        final List<dynamic>? descriptionList =
            result['properties']['Description']?['rich_text'];
        final String description =
            (descriptionList != null && descriptionList.isNotEmpty)
                ? (descriptionList.first['plain_text'] ?? '')
                : '';

        tasks.add(Task.fromJson({
          'id': result['id'],
          'title': title,
          'status': status,
          'due_date': dueDateString,
          'priority': priority,
          'description': description,
        }));
      }
      return tasks;
    } else {
      throw Exception('Failed to load tasks from Notion');
    }
  }

  // createTask(), updateTask(), deleteTask() は以前のコードと同様
  Future<void> createTask(Task task) async {
    if (_accessToken == null) throw Exception('Not authenticated with Notion');
    final url = 'https://api.notion.com/v1/pages';
    final body = jsonEncode({
      'parent': {'database_id': dotenv.env['NOTION_DATABASE_ID']},
      'properties': {
        'Name': {
          'title': [
            {
              'text': {'content': task.title}
            }
          ]
        },
        'Status': {
          'select': {'name': task.status}
        },
        'Due Date': {
          'date': task.dueDate != null
              ? {'start': task.dueDate!.toIso8601String()}
              : null
        },
        'Priority': {
          'select': task.priority != null ? {'name': task.priority} : null
        },
        'Description': {
          'rich_text': task.description != null
              ? [
                  {
                    'text': {'content': task.description}
                  }
                ]
              : [],
        },
      },
    });
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create task in Notion');
    }
  }

  Future<void> updateTask(Task task) async {
    if (_accessToken == null) throw Exception('Not authenticated with Notion');
    final url = 'https://api.notion.com/v1/pages/${task.id}';
    final body = jsonEncode({
      'properties': {
        'Name': {
          'title': [
            {
              'text': {'content': task.title}
            }
          ]
        },
        'Status': {
          'select': {'name': task.status}
        },
        'Due Date': {
          'date': task.dueDate != null
              ? {'start': task.dueDate!.toIso8601String()}
              : null
        },
        'Priority': {
          'select': task.priority != null ? {'name': task.priority} : null
        },
        'Description': {
          'rich_text': task.description != null
              ? [
                  {
                    'text': {'content': task.description}
                  }
                ]
              : [],
        },
      },
    });
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task in Notion');
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (_accessToken == null) throw Exception('Not authenticated with Notion');
    final url = 'https://api.notion.com/v1/pages/$taskId';
    final body = jsonEncode({'archived': true});
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete (archive) task in Notion');
    }
  }
}
