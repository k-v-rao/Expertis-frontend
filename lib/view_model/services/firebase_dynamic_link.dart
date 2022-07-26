import 'package:beamer/beamer.dart';
import 'package:expertis/models/shop_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DynamicLinksService {
  static Future<String> createShopDynamicLink(ShopModel shop,
      {bool short = false}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName);
    String uriPrefix = "https://expertis.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse(
          'https://expertis-web.vercel.app/shops/view/${shop.shopId}'),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            'https://expertis-web.vercel.app/shops/view/${shop.shopId}'),
        packageName: packageInfo.packageName,
        minimumVersion: 125,
      ),
      iosParameters: IOSParameters(
        fallbackUrl: Uri.parse(
            'https://expertis-web.vercel.app/shops/view/${shop.shopId}'),
        bundleId: packageInfo.packageName,
        minimumVersion: packageInfo.version,
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'Share',
        medium: 'social',
        source: 'app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: shop.shopName,
          description: shop.about,
          imageUrl: Uri.parse(
            shop.shopLogo ??
                'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
          )),
    );

    // final Uri dynamicUrl = await parameters.buildUrl();
    Uri url;
    if (short) {
      final ShortDynamicLink shortDynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortDynamicLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }

    return url.toString();
  }

  // static void initDynamicLinks(BuildContext context) async {
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();

  //   _handleDynamicLink(data, context);

  //   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  //     _handleDynamicLink(dynamicLinkData, context);
  //   }).onError((error) {
  //     print(error.toString());
  //     // Handle errors
  //   });

  //   // FirebaseDynamicLinks.instance.onLink(
  //   //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //   //   _handleDynamicLink(dynamicLink);
  //   // }, onError: (OnLinkErrorException e) async {
  //   //   print('onLinkError');
  //   //   print(e.message);
  //   // });
  // }

  static _handleDynamicLink(
      PendingDynamicLinkData? data, BuildContext context) async {
    final Uri? deepLink = data?.link;

    if (deepLink == null) {
      return;
    }
    print('deep link is ${deepLink.path.toString()}');
    // Beamer.of(context).beamToNamed(deepLink.path);
    // var isShop = data!.link.path.contains('shops/view');
    // if (isShop) {
    //   Beamer.of(context).beamToNamed(data.link.path.split('/').last);
    // }
    // if (deepLink.pathSegments.contains('refer')) {
    //   var title = deepLink.queryParameters['code'];
    //   if (title != null) {
    //     print("refercode=$title");
    //   }
    // }
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDynamicLink(dynamicLinkData, context);
      // Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      // Handle errors
    });

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      _handleDynamicLink(initialLink, context);
      // Example of using the dynamic link to push the user to a different screen
      // Navigator.pushNamed(context, deepLink.path);
    }
  }
}
