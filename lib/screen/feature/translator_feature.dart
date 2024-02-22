import 'package:ai_assistant_bot/controller/native_ad_controller.dart';
import 'package:ai_assistant_bot/helper/ad_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../controller/image_controller.dart';
import '../../controller/translate_controller.dart';

import '../../helper/global.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_loading.dart';
import '../../widget/language_sheet.dart';

class TranslatorFeature extends StatefulWidget {
  const TranslatorFeature({super.key});

  @override
  State<TranslatorFeature> createState() => _TranslatorFeatureState();
}

class _TranslatorFeatureState extends State<TranslatorFeature> {
  final _c = TranslateController();
  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAd(addController: _adController);
    return Obx(() =>
        Scaffold(
        //app bar
        appBar: AppBar(
          title: const Text('Multi Language Translator'),
        ),
        bottomNavigationBar: _adController.ad != null &&
            _adController.adLoaded.isTrue
            ? SafeArea(
            child:
            SizedBox(height: 350, child: AdWidget(ad: _adController.ad!)))
            : null,

        // //body
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              top: mq.height * .02, bottom: mq.height * .1),
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //from language
              InkWell(
                onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.from)),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  height: 50,
                  width: mq.width * .4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(15))),
                  child:
                  Obx(() => Text(_c.from.isEmpty ? 'Auto' : _c.from.value)),
                ),
              ),
              //
              //       //swipe language btn
              IconButton(
                  onPressed: _c.swapLanguages,
                  icon: Obx(
                        () =>
                        Icon(
                          CupertinoIcons.repeat,
                          color: _c.to.isNotEmpty && _c.from.isNotEmpty
                              ? Colors.blue
                              : Colors.grey,
                        ),
                  )),
              //
              //       //to language
              InkWell(
                onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.to)),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  height: 50,
                  width: mq.width * .4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(15))),
                  child: Obx(() => Text(_c.to.isEmpty ? 'To' : _c.to.value)),
                ),
              ),
            ]),


            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * .04, vertical: mq.height * .035),
              child: TextFormField(
                controller: _c.textC,
                minLines: 5,
                maxLines: null,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                    hintText: 'Translate anything you want...',
                    hintStyle: TextStyle(fontSize: 13.5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),


            Obx(() => _translateResult()),

            SizedBox(height: mq.height * .0),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomBtn(onTap: _c.googleTranslate, text: 'Go-Translate'),
                CustomBtn(onTap: _c.translate, text: 'AI-Translate'),

              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _translateResult() =>
      switch (_c.status.value) {
        Status.none => const SizedBox(),
        Status.complete =>
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              child: TextFormField(
                controller: _c.resultC,
                maxLines: null,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
        Status.loading => const Align(child: CustomLoading())
      };
}
