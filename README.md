# notion_gtd_manager

This is Notion GTD task manager.

## Getting Started
# Notion GTD Manager

**Notion GTD Manager** は、Firebase によるアカウント登録後、Notion API と連携してタスク管理用テンプレート（Tasks データベース、GTD Dashboard ページ）を自動生成するタスク管理アプリです。  
GTD（Getting Things Done）方式に基づいたタスク管理を実現し、Notion 風のシンプルかつミニマルな UI、ダークモード切替、レスポンシブ対応のモバイルアプリとして設計されています。

## 特徴

- **Firebase アカウント登録**
    - 初回ログインは Firebase Authentication を利用（例：匿名ログイン、メール／パスワード認証等に拡張可能）
    - ログイン後はアカウント状態が保持されます

- **オンボーディング (初回のみ表示)**
    - ユーザー毎に初回のみオンボーディング画面を表示し、利用方法や Notion 連携の手順を案内
    - オンボーディング完了後は再表示されません

- **Notion 連携**
    - Notion の OAuth 連携を用いて、ユーザーの Notion アカウントにタスク管理用テンプレート（Tasks データベース、GTD Dashboard）を自動生成
    - 設定画面から連携解除／再連携が可能

- **GTD タスク管理**
    - タスクを「Inbox」「Next Action」「Waiting」「Completed」などのステータスで管理
    - Notion 上のデータベースと連携し、双方向同期を実現

- **Notion っぽい UI**
    - シンプルかつミニマルなデザイン
    - 提供カラーコード（あか、あお、みどり、きいろ、オレンジ、ちゃいろ、はいいろ、むらさき、ぴんく）を活用
    - Dark Mode 切替、レスポンシブ対応

- **技術スタック**
    - Flutter (Dart)
    - Firebase Authentication
    - Riverpod による状態管理
    - Notion API 連携

## ディレクトリ構造
```
notion_gtd_manager/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── config/
│       │   ├── constants.dart      // 定数（カラーコード等）の定義
│       │   └── theme.dart          // Light/Dark テーマ設定
│       │
│       ├── models/
│       │   └── task.dart           // Task モデル
│       │
│       ├── providers/
│       │   ├── auth_provider.dart       // Firebase 認証とオンボーディング状態管理
│       │   ├── task_provider.dart       // タスク一覧管理（Riverpod StateNotifier）
│       │   └── notion_provider.dart     // Notion 連携状態管理
│       │
│       ├── services/
│       │   ├── firebase_auth_service.dart   // Firebase 認証処理
│       │   └── notion_api_service.dart        // Notion API 呼び出し処理
│       │
│       ├── screens/
│       │   ├── auth_wrapper.dart        // ログイン／オンボーディング／ホーム画面への遷移制御
│       │   ├── login_screen.dart        // Firebase によるアカウント登録／ログイン画面
│       │   ├── onboarding_screen.dart   // 初回のみ表示するオンボーディング画面
│       │   ├── home_screen.dart         // タスク一覧（GTD Dashboard）画面
│       │   ├── settings_screen.dart     // 設定画面（DarkMode 切替、Notion 連携解除等）
│       │   └── task_detail_screen.dart  // タスク詳細／編集画面（必要に応じて）
│       │
│       └── widgets/
│           └── task_card.dart       // タスク表示用ウィジェット
│
├── assets/
│   ├── images/
│   └── fonts/
│
├── pubspec.yaml
└── README.md
```
