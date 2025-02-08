import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/theme.dart';
import '../services/firebase_auth_service.dart';
import '../services/notion_api_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref.read(themeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          ListTile(
            title: const Text('Notion 連携解除'),
            onTap: () {
              ref.read(notionApiServiceProvider).clearAccessToken();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notion連携を解除しました')));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuthService().signOut();
            },
          ),
        ],
      ),
    );
  }
}
