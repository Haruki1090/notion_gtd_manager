import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_gtd_manager/src/config/theme.dart';
import 'package:notion_gtd_manager/src/screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: NotionGTDManagerApp()));
}

class NotionGTDManagerApp extends ConsumerWidget {
  const NotionGTDManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Notion GTD Manager',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const AuthWrapper(),
    );
  }
}
