import 'dart:developer';

import 'package:ai_assistant_bot/main.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../controller/chat_controller.dart';
import '../../helper/global.dart';
import '../../utils/colors.dart';
import '../../widget/message_card.dart';

class ChatBotFeature extends StatefulWidget {
  const ChatBotFeature({super.key});

  @override
  State<ChatBotFeature> createState() => _ChatBotFeatureState();
}

class _ChatBotFeatureState extends State<ChatBotFeature> {
  final _c = ChatController();
  // final _adController = NativeAdController();
  final _voidController = ChatController();
  final _messageController = TextEditingController();

  SpeechToText speechToText = SpeechToText();

  var text = "";
  var isListening = false;


  @override
  Widget build(BuildContext context) {
   // _adController.ad = AdHelper.loadNativeAdSmall(addController: _adController);
    return Scaffold(
        //app bar
        appBar: AppBar(
          title: const Text('Chat with AI Bot'),
        ),

        //send message field & btn
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              children: [
                //text input field
                AvatarGlow(
                  duration: const Duration(milliseconds: 2000),
                  glowColor: bgColor,
                  repeat: true,
                  glowShape: BoxShape.circle,
                  animate:isListening,
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTapDown: (details) async{
                      if(!isListening) {
                        var available = await speechToText.initialize();
                        if(available){
                          setState(() {
                            isListening = true;
                            speechToText.listen(
                                onResult: (result){
                                  setState(() {
                                    // _voidController.textB.text = text;
                                     _voidController.textB.text = text;
                                     text = result.recognizedWords;
                                    log('Voice : $text');
                                  });
                                }
                            );

                          });
                        }
                      }
                    },

                    onTapUp: (details){
                      setState(() {
                        isListening = false;
                      });
                      speechToText.stop();

                    },

                    child: CircleAvatar(
                      backgroundColor: bgColor,
                      radius: 24,
                      child: Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.white,),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                    child: TextFormField(
                      controller: _c.textC ,
                      textAlign: TextAlign.center,
                      onTapOutside: (e) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                          fillColor: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                          filled: true,
                          isDense: true,
                          hintText: 'Ask me anything you want...',
                          hintStyle: const TextStyle(fontSize: 14),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  50)))),
                    )),


                const SizedBox(width: 8),

                //send button
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme
                      .of(context)
                      .buttonColor,
                  child: IconButton(
                    onPressed: _c.askQuestion,
                    icon: const Icon(Icons.rocket_launch_rounded,
                        color: Colors.white, size: 28),
                  ),
                ),

                //Add New Feature for new Update Text to Speech

              ]),
        ),

        //body
        body: Obx(
              () =>
              ListView(
                physics: const BouncingScrollPhysics(),
                controller: _c.scrollC,
                padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .15),
                children: _c.list.map((e) => MessageCard(message: e)).toList(),
              ),
        ),
      );

  }
}
