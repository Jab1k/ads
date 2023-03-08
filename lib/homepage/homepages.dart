// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobPage extends StatefulWidget {
  const AdmobPage({Key? key}) : super(key: key);

  @override
  State<AdmobPage> createState() => _AdmobPageState();
}

class _AdmobPageState extends State<AdmobPage> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  final adrevarded = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';
  final admobId = Platform.isAndroid
      ? 'ca-app-pub-6904776448367697/8324721692'
      : 'ca-app-pub-6904776448367697/8324721692';

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-6904776448367697/8028142564'
      : 'ca-app-pub-6904776448367697/8028142564';
  void rewardedAd() {
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: admobId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: ${err.message} ');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadAd2() {
    _isLoaded = true;
    setState(() {});
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));

    _isLoaded = false;
    setState(() {});
  }

  @override
  void initState() {
    loadAd();
    rewardedAd();
    loadAd2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            if (_bannerAd != null)
              SizedBox(
                width: _bannerAd?.size.width.toDouble(),
                height: _bannerAd?.size.height.toDouble(),
                child: AdWidget(
                  ad: _bannerAd!,
                ),
              ),
            const SizedBox(
              height: 32,
            ),
            if (_interstitialAd != null)
              ElevatedButton(
                onPressed: () {
                  _interstitialAd!.show();
                },
                child: _isLoaded
                    ? const CircularProgressIndicator()
                    : const Text('AdMob InterstitialAd'),
              ),
            if (_rewardedAd != null)
              ElevatedButton(
                onPressed: () {
                  _rewardedAd!.show(
                      onUserEarnedReward:
                          (AdWithoutView ad, RewardItem reward) {});
                },
                child: _isLoaded
                    ? const CircularProgressIndicator()
                    : const Text('AdMob rewarder'),
              )
          ],
        ),
      ),
    );
  }
}
