import 'dart:developer';
import 'package:appwrite/appwrite.dart';

import '../helper/global.dart';

class AppWrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static void init() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65d452830fced5f37600')
        .setSelfSigned(status: true);
    getBgApiKey();
    getApiKey();

  }

  static Future<String> getApiKey() async {
    try {
      final d = await _database.getDocument(
          databaseId: 'MyDatabase',
          collectionId: 'ApiKey',
          documentId: 'chatGptKey');

      apiKey = d.data['apiKey'];
      log('apikey $apiKey');
      return apiKey;
    } catch (e) {
      log('$e');
      return '';
    }
  }

  static Future<String> getBgApiKey() async {
    try {
      final bg = await _database.getDocument(
          databaseId: 'MyDatabase',
          collectionId: 'bgKey',
          documentId: 'bgRemoveKey');

      apiKeyBg = bg.data['BgKey'];
      log('BgApiKey $apiKeyBg');
      return apiKeyBg;
    } catch (e) {
      log('$e');
      return '';
    }
  }
}


// Client client = Client();
// client
//     .setEndpoint('https://cloud.appwrite.io/v1')
// .setProject('65e195b14121a0dd5c47')
//     .setSelfSigned(status: true); // For self signed certificates, only use for development
