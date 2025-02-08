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
        final List<dynamic>? titleList = result['properties']['Name']['title'];
        final String title = (titleList != null && titleList.isNotEmpty)
            ? (titleList.first['plain_text'] ?? '')
            : '';

        final String status =
            result['properties']['Status']['select']?['name'] ?? '';

        final String? dueDateString =
            result['properties']['Due Date']?['date']?['start'];
        final DateTime? dueDate =
            dueDateString != null ? DateTime.tryParse(dueDateString) : null;

        final String priority =
            result['properties']['Priority']['select']?['name'] ?? '';

        final List<dynamic>? descriptionList =
            result['properties']['Description']?['rich_text'];
        final String description =
            (descriptionList != null && descriptionList.isNotEmpty)
                ? (descriptionList.first['plain_text'] ?? '')
                : '';

        // タグ（Notion の multi_select プロパティの場合、リスト内の各要素の name を抽出）
        final List<dynamic>? tagsList =
            result['properties']['Tags']?['multi_select'];
        final List<String> tags = tagsList != null
            ? tagsList.map((tag) => tag['name'] as String).toList()
            : [];

        tasks.add(Task.fromJson({
          'id': result['id'],
          'title': title,
          'status': status,
          'due_date': dueDateString,
          'priority': priority,
          'description': description,
          'tags': tags,
        }));
      }
      return tasks;
    } else {
      throw Exception('Failed to load tasks from Notion');
    }
  }

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
        'Tags': {
          'multi_select': task.tags != null
              ? task.tags!.map((tag) => {'name': tag}).toList()
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
        'Tags': {
          'multi_select': task.tags != null
              ? task.tags!.map((tag) => {'name': tag}).toList()
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
