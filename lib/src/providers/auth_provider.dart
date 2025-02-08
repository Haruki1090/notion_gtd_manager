import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//このコードは、Firebase 認証と `shared_preferences` を使用してユーザーの認証状態とオンボーディングの完了状態を管理するためのプロバイダーを定義しています。

//- `AuthState` クラス: ユーザーの認証状態 (`user`) とオンボーディングの完了状態 (`onboardingCompleted`) を保持するデータクラスです。
//- `AuthNotifier` クラス: `StateNotifier` を継承し、`AuthState` を管理します。Firebase の認証状態を監視し、状態を更新します。また、オンボーディングの完了状態を `shared_preferences` に保存します。
//- `authStateProvider`: `AuthNotifier` を提供する `StateNotifierProvider` です。これにより、アプリ全体で認証状態を監視および管理できます。

class AuthState {
  final User? user;
  final bool onboardingCompleted;
  AuthState({this.user, this.onboardingCompleted = false});

  AuthState copyWith({
    User? user,
    bool? onboardingCompleted,
  }) {
    return AuthState(
      user: user ?? this.user,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    // Firebase の認証状態を監視
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      final prefs = await SharedPreferences.getInstance();
      final seenOnboarding = prefs.getBool('onboarding_completed') ?? false;
      state = AuthState(user: user, onboardingCompleted: seenOnboarding);
    });
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    state = state.copyWith(onboardingCompleted: true);
  }
}

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
