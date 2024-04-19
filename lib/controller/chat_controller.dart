import 'package:ai_assistant_bot/screen/feature/chat_bot_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/apis.dart';
import '../helper/my_dialog.dart';
import '../model/message.dart';

class ChatController extends GetxController {
  final textC = TextEditingController();
  final textB = TextEditingController();

  final scrollC = ScrollController();

  final list = <Message>[
    Message(msg: 'Hello, How can I help you?', msgType: MessageType.bot)
  ].obs;

  Future<void> askQuestion() async {
    if (textC.text.trim().isNotEmpty  ) {
      //user
      list.add(Message(msg: textC.text, msgType: MessageType.user));
      list.add(Message(msg: '', msgType: MessageType.bot));
      _scrollDown();

      final res = await APIs.getAnswer(textC.text);

      //ai bot
      list.removeLast();
      list.add(Message(msg: res, msgType: MessageType.bot));
      _scrollDown();

      textC.text = '';
    }
    else if(textB.text.trim().isNotEmpty){
      list.add(Message(msg: textB.text, msgType: MessageType.user));
      list.add(Message(msg: '', msgType: MessageType.bot));
      _scrollDown();

      final res = await APIs.getAnswer(textB.text);

      //ai bot
      list.removeLast();
      list.add(Message(msg: res, msgType: MessageType.bot));
      _scrollDown();

      textB.text = '';

    }


    else {
      MyDialog.info('Ask me Something!');
    }
  }

  //for moving to end message
  void _scrollDown() {
    scrollC.animateTo(scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
