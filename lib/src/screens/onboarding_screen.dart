// lib/src/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Welcome to Notion GTD Manager!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text('This onboarding is shown only once per user.'),
            // オンボーディング内容（使い方や Notion 連携の手順などを記載）
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                // オンボーディング完了状態を更新
                await ref.read(authStateProvider.notifier).completeOnboarding();
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
