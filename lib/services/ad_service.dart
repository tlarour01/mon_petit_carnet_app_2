import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String get bannerAdUnitId {
    // Using test ad unit IDs for development
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }
}

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdService.createBannerAd();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd.load().then((_) {
      if (mounted) {
        setState(() {
          _isAdLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
      return const SizedBox(height: 50);
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final maxAdHeight = screenHeight * 0.15; // 15% of screen height
    final adHeight = _bannerAd.size.height.toDouble();

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxAdHeight,
      ),
      height: adHeight,
      child: AdWidget(ad: _bannerAd),
    );
  }
}