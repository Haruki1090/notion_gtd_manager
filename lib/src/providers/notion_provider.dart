import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/notion_api_service.dart';

final notionAuthProvider = StateProvider<bool>((ref) => false);

class NotionAuthNotifier extends StateNotifier<bool> {
  final NotionApiService notionApi;

  NotionAuthNotifier(this.notionApi) : super(false);

  void authenticate(String token) {
    notionApi.setAccessToken(token);
    state = true;
  }

  void logout() {
    notionApi.setAccessToken(null);
    state = false;
  }
}
