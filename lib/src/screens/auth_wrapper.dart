// lib/src/screens/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    if (authState.user == null) {
      // 未ログインの場合はログイン画面を表示
      return const LoginScreen();
    } else {
      // ログイン済みの場合、オンボーディング完了状態に応じて遷移
      return authState.onboardingCompleted
          ? const HomeScreen()
          : const OnboardingScreen();
    }
  }
}
