import 'package:ai_assistant_bot/helper/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screen/feature/background_remove.dart';
import '../screen/feature/chat_bot_feature.dart';
import '../screen/feature/image_feature.dart';
import '../screen/feature/translator_feature.dart';

enum HomeType { aiChatBot, aiImage, aiTranslator, aiBGRemove }

extension MyHomeType on HomeType {
  //title
  String get title => switch (this) {
        HomeType.aiChatBot => 'AI ChatBot',
        HomeType.aiImage => 'AI Image Creator',
        HomeType.aiTranslator => 'Language Translator',
        HomeType.aiBGRemove => 'Background \nRemove',
      };

  //lottie
  String get lottie => switch (this) {
        HomeType.aiChatBot => 'chat_bot.json',
        HomeType.aiImage => 'ai_play.json',
        HomeType.aiTranslator => 'language_translator.json',
        HomeType.aiBGRemove => 'background_remover.json',
      };

  //for alignment
  bool get leftAlign => switch (this) {
        HomeType.aiChatBot => true,
        HomeType.aiImage => false,
        HomeType.aiTranslator => true,
        HomeType.aiBGRemove => false,
      };

  //for padding
  EdgeInsets get padding => switch (this) {
        HomeType.aiChatBot => EdgeInsets.zero,
        HomeType.aiImage => const EdgeInsets.all(20),
        HomeType.aiTranslator => EdgeInsets.zero,
        HomeType.aiBGRemove => const EdgeInsets.all(20),
      };

  //for navigation
  VoidCallback get onTap => switch (this) {
        HomeType.aiChatBot => () => AdHelper.showLoadInterstitialAd(
              onComplete: () => Get.to(() => const ChatBotFeature()),
            ),
        HomeType.aiImage => () => AdHelper.showLoadInterstitialAd(
              onComplete: () => Get.to(() => const ImageFeature()),
            ),
        HomeType.aiTranslator => () => AdHelper.showLoadInterstitialAd(
              onComplete: () => Get.to(() => const TranslatorFeature()),
            ),
        HomeType.aiBGRemove => () => AdHelper.showLoadInterstitialAd(
              onComplete: () => Get.to(() => const BackgroundRemove()),
            ),
      };
}
