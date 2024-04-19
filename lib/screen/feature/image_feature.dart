import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../controller/image_controller.dart';
import '../../controller/native_ad_controller.dart';
import '../../helper/ad_helper.dart';
import '../../helper/global.dart';
import '../../utils/colors.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_loading.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  SpeechToText speechToText = SpeechToText();
  var text = "Hold the button and start speaking";
  var isListening = false;
  final _c = ImageController();
  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAdSmall(addController: _adController);
    return Obx(() =>
        Scaffold(
        //app bar
        appBar: AppBar(
          title: const Text('AI Image Creator'),

          //share btn
          actions: [
            Obx(
                  () =>
              _c.status.value == Status.complete
                  ? IconButton(
                  padding: const EdgeInsets.only(right: 6),
                  onPressed: _c.shareImage,
                  icon: const Icon(Icons.share))
                  : const SizedBox(),
            )
          ],
        ),

        bottomNavigationBar: _adController.ad != null &&
            _adController.adLoaded.isTrue
            ? SafeArea(
            child:
            SizedBox(height: 80, child: AdWidget(ad: _adController.ad!)))
            : null,

        // //download btn
        floatingActionButton: Obx(() =>
        _c.status.value == Status.complete
            ? Padding(
          padding: const EdgeInsets.only(right: 6, bottom: 6),
          child: FloatingActionButton(
            onPressed: _c.downloadImage,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Icon(Icons.save_alt_rounded, size: 26),
          ),
        )
            : const SizedBox()),

        // //body
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              top: mq.height * .02,
              bottom: mq.height * .1,
              left: mq.width * .04,
              right: mq.width * .04),
          children: [
            //text field
            TextFormField(
              controller: _c.textC,
              textAlign: TextAlign.center,
              minLines: 2,
              maxLines: null,
              onTapOutside: (e) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                  hintText:
                  'Imagine something wonderful & innovative\nType here & I will create for you..',
                  hintStyle: TextStyle(fontSize: 13.5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),

            //     //ai image
            Container(
                height: mq.height * .35,
                margin: EdgeInsets.symmetric(vertical: mq.height * .0),
                alignment: Alignment.center,
                child: Obx(() => _aiImage())),

            Obx(() =>
            _c.imageList.isEmpty
                ? const SizedBox()
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(bottom: mq.height * .03),
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                spacing: 10,
                children: _c.imageList
                    .map((e) =>
                    InkWell(
                      onTap: () {
                        _c.url.value = e;
                      },
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8)),
                        child: CachedNetworkImage(
                          imageUrl: e,
                          height: 100,
                          errorWidget: (context, url, error) =>
                          const SizedBox(),
                        ),
                      ),
                    ))
                    .toList(),
              ),
            )),

            //create btn


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                CustomBtn(onTap: _c.searchAiImage, text: 'Google '),
                const SizedBox(width: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                          radius: 25,
                          child: Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.white,),
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(width: 2,),
                CustomBtn(onTap: _c.createAIImage, text: 'AI'),

              ],
            ),




          ],
        ),
      ));
  }

  Widget _aiImage() =>
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: switch (_c.status.value) {
          Status.none =>
              Lottie.asset(
                  'assets/lottie/ai_play.json', height: mq.height * .3),
          Status.complete =>
              CachedNetworkImage(
                imageUrl: _c.url.value,
                placeholder: (context, url) => const CustomLoading(),
                errorWidget: (context, url, error) => const SizedBox(),
              ),
          Status.loading => const CustomLoading()
        },
      );
}
