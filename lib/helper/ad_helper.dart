import 'dart:developer';

import 'package:ai_assistant_bot/helper/my_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controller/native_ad_controller.dart';

class AdHelper {
  // for initializing ads sdk
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  static showLoadInterstitialAd({required VoidCallback onComplete}) {
    MyDialog.showProgress();

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8833838626334586/6974708479',//original Ads
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712..', // test IDs
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              onComplete();
            },
          );
          ad.show();
          Get.back();
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }

  static NativeAd loadNativeAd({required NativeAdController addController}) {
    return NativeAd(
        adUnitId: 'ca-app-pub-8833838626334586/5234514728', // Original Ads ID
        //adUnitId: 'ca-app-pub-3940256099942544/2247696110..', // Test IDs
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            log('Native Ad Id: $NativeAd');
            addController.adLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.medium))
      ..load();
  }

  static NativeAd loadNativeAdSmall(
      {required NativeAdController addController}) {
    return NativeAd(
        adUnitId: 'ca-app-pub-8833838626334586/5234514728', // Original IDs
        // adUnitId: 'ca-app-pub-3940256099942544/2247696110..', // Test IDs
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            log('Native Ad Id: $NativeAd');
            addController.adLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small))
      ..load();
  }
}
