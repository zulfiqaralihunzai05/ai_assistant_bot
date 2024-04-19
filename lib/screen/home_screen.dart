import 'package:ai_assistant_bot/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controller/native_ad_controller.dart';
import '../helper/ad_helper.dart';
import '../helper/global.dart';
import '../helper/pref.dart';
import '../model/home_type.dart';
import '../widget/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _adController = NativeAdController();
  final _isDarkMode = Pref.isDarkMode.obs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;
  }

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAdSmall(addController: _adController);
    //initializing device size
    mq = MediaQuery.sizeOf(context);


    return Obx(() =>
      Scaffold(
        backgroundColor: TColors.background,
        appBar: AppBar(
          title: const Text(
            appName,
            style: TextStyle(color: TColors.textColor),
          ),

          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {
                 AdHelper.showLoadInterstitialAd(onComplete: (){
                   Get.changeThemeMode(
                       _isDarkMode.value ? ThemeMode.light : ThemeMode.dark);

                   _isDarkMode.value = !_isDarkMode.value;
                   Pref.isDarkMode = _isDarkMode.value;
                 });
                },
                icon: Obx(() =>
                    Icon(
                        _isDarkMode.value
                            ? Icons.brightness_2_rounded
                            : Icons.brightness_5_rounded,
                        color: TColors.textColor,
                        size: 26)))
          ],
        ),
        bottomNavigationBar: _adController.ad != null &&
            _adController.adLoaded.isTrue
            ? SafeArea(
            child:
            SizedBox(height: 80, child: AdWidget(ad: _adController.ad!)))
            : null,


        ///body
        body: ListView(

          padding: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .015),
          children: HomeType.values.map((e) => HomeCard(homeType: e)).toList(),
        ),
      ));
  }
}
