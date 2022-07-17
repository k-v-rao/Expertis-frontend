import 'package:expertis/data/response/status.dart';
import 'package:expertis/screens/BMCallScreen.dart';
import 'package:expertis/screens/BMChatScreen.dart';
import 'package:expertis/utils/utils.dart';
import 'package:expertis/view_model/shop_view_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../components/BMOurServiveComponent.dart';
import '../components/BMPortfolioComponent.dart';
import '../main.dart';
import '../models/BMCommonCardModel.dart';
import '../models/BMMessageModel.dart';
import '../models/shop_list_model.dart';
import '../utils/BMColors.dart';
import '../utils/BMWidgets.dart';
import '../utils/flutter_rating_bar.dart';
import 'BMSingleImageScreen.dart';

class BMSingleComponentScreen extends StatefulWidget {
  ShopModel element = ShopModel();
  String shopId;
  BMSingleComponentScreen({Key? key, required this.shopId}) : super(key: key);

  @override
  _BMSingleComponentScreenState createState() =>
      _BMSingleComponentScreenState();
}

class _BMSingleComponentScreenState extends State<BMSingleComponentScreen> {
  ShopViewModel shopViewModel = ShopViewModel();
  bool isLiked = false;
  String defaultImg = "https://www.totallyrepair.in/images/wow-5.jpg";
  List<String> tabList = [
    'OUR SERVICES',
    'PORTFOLIO',
    'STORE',
    'ABOUT',
    'REVIEW'
  ];

  int selectedTab = 0;

  Widget getSelectedTabComponent() {
    if (selectedTab == 0) {
      return BMOurServiveComponent();
    } else {
      return BMPortfolioComponent();
    }
  }

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    shopViewModel.fetchSelectedShopDataApi(widget.shopId);
    super.initState();
  }

  @override
  void dispose() {
    shopViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.shopId);
    bool isLiked = false;
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn
          ? appStore.scaffoldBackground!
          : bmLightScaffoldBackgroundColor,
      body: ChangeNotifierProvider<ShopViewModel>(
        create: (BuildContext context) => shopViewModel,
        child: Consumer<ShopViewModel>(builder: (context, value, _) {
          switch (value.selectedShop.status) {
            case Status.LOADING:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case Status.ERROR:
              String error = value.selectedShop.message.toString();
              return Utils.findErrorPage(context, error);

            case Status.COMPLETED:
              ShopModel? shop = value.selectedShop.data;
              return NestedScrollView(
                floatHeaderSlivers: true,
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: appStore.isDarkModeOn
                          ? appStore.scaffoldBackground!
                          : bmLightScaffoldBackgroundColor,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: bmPrimaryColor),
                        onPressed: () {
                          finish(context);
                        },
                      ).visible(innerBoxIsScrolled),
                      title: titleText(title: shop!.shopName ?? '')
                          .visible(innerBoxIsScrolled),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.subdirectory_arrow_right,
                              color: bmPrimaryColor),
                          onPressed: () {
                            // BMSingleImageScreen(element: widget.element)
                            // .launch(context);
                          },
                        ).visible(innerBoxIsScrolled),
                        IconButton(
                          icon: isLiked
                              ? Icon(Icons.favorite, color: bmPrimaryColor)
                              : Icon(Icons.favorite_outline,
                                  color: bmPrimaryColor),
                          onPressed: () {
                            isLiked = !isLiked;
                            setState(() {});
                          },
                        ).visible(innerBoxIsScrolled),
                      ],
                      leadingWidth: 30,
                      pinned: true,
                      elevation: 0.5,
                      expandedHeight: 450,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding:
                            EdgeInsets.only(bottom: 66, left: 30, right: 50),
                        collapseMode: CollapseMode.parallax,
                        background: Column(
                          children: [
                            Stack(
                              children: [
                                Image.network(
                                  shop.shopLogo ?? defaultImg,
                                  height: 300,
                                  width: context.width(),
                                  fit: BoxFit.cover,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Icon(Icons.arrow_back,
                                          color: bmPrimaryColor),
                                      decoration: BoxDecoration(
                                        borderRadius: radius(100),
                                        color: context.cardColor,
                                      ),
                                      padding: EdgeInsets.all(8),
                                      margin:
                                          EdgeInsets.only(left: 16, top: 30),
                                    ).onTap(() {
                                      finish(context);
                                    }, borderRadius: radius(100)),
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                              Icons.subdirectory_arrow_right,
                                              color: bmPrimaryColor),
                                          decoration: BoxDecoration(
                                            borderRadius: radius(100),
                                            color: context.cardColor,
                                          ),
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.only(
                                              right: 16, top: 30),
                                        ).onTap(() {
                                          // BMSingleImageScreen(
                                          //         element: widget.element)
                                          //     .launch(context);
                                        }, borderRadius: radius(100)),
                                        Container(
                                          child: isLiked
                                              ? Icon(Icons.favorite,
                                                  color: bmPrimaryColor)
                                              : Icon(Icons.favorite_outline,
                                                  color: bmPrimaryColor),
                                          decoration: BoxDecoration(
                                            borderRadius: radius(100),
                                            color: context.cardColor,
                                          ),
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.only(
                                              right: 16, top: 30),
                                        ).onTap(() {
                                          isLiked = !isLiked;
                                          setState(() {});
                                        }, borderRadius: radius(100)),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              color: appStore.isDarkModeOn
                                  ? appStore.scaffoldBackground!
                                  : bmLightScaffoldBackgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titleText(title: shop.shopName ?? ''),
                                  8.height,
                                  Text(
                                    shop.contact!.address ?? '',
                                    style: secondaryTextStyle(
                                        color: appStore.isDarkModeOn
                                            ? Colors.white
                                            : bmPrimaryColor,
                                        size: 12),
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      Text(shop.rating!.avg.toString(),
                                          style: boldTextStyle()),
                                      2.width,
                                      RatingBar(
                                        initialRating:
                                            shop.rating!.avg!.toDouble(),
                                        minRating: 5,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 18,
                                        itemPadding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          //
                                        },
                                      ),
                                      6.width,
                                      Text(
                                          shop.rating!.totalMembers!.toString(),
                                          style: secondaryTextStyle(
                                              color: bmTextColorDarkMode)),
                                    ],
                                  ),
                                  8.height,
                                  Wrap(
                                    spacing: 16,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: bmPrimaryColor),
                                          color: appStore.isDarkModeOn
                                              ? appStore.scaffoldBackground!
                                              : bmLightScaffoldBackgroundColor,
                                          borderRadius: radius(32),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.call_outlined,
                                                color: bmPrimaryColor),
                                            4.width,
                                            Text('Call us',
                                                style: boldTextStyle(
                                                    color: bmPrimaryColor)),
                                          ],
                                        ),
                                      ).onTap(() {
                                        BMCallScreen().launch(context);
                                      }, borderRadius: radius(32)),
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: bmPrimaryColor),
                                          color: appStore.isDarkModeOn
                                              ? appStore.scaffoldBackground!
                                              : bmLightScaffoldBackgroundColor,
                                          borderRadius: radius(32),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset('images/chat.png',
                                                height: 20,
                                                color: bmPrimaryColor),
                                            8.width,
                                            Text('Send Message',
                                                style: boldTextStyle(
                                                    color: bmPrimaryColor)),
                                          ],
                                        ),
                                      ).onTap(() {
                                        BMChatScreen(
                                            element: BMMessageModel(
                                          image: shop.shopLogo ?? defaultImg,
                                          name: shop.shopName ?? '',
                                          message:
                                              'Do you want to confirm yor appointment?',
                                          isActive: false,
                                          lastSeen: 'today , at 11:30 am',
                                        )).launch(context);
                                      }),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  decoration: BoxDecoration(
                    color: appStore.isDarkModeOn
                        ? bmSecondBackgroundColorDark
                        : bmSecondBackgroundColorLight,
                    borderRadius: radiusOnly(topLeft: 32, topRight: 32),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        16.height,
                        HorizontalList(
                          itemCount: tabList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: radius(32),
                                color: selectedTab == index
                                    ? bmPrimaryColor
                                    : Colors.transparent,
                              ),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                tabList[index],
                                style: boldTextStyle(
                                  size: 12,
                                  color: selectedTab == index
                                      ? white
                                      : appStore.isDarkModeOn
                                          ? bmPrimaryColor
                                          : bmSpecialColorDark,
                                ),
                              ).onTap(() {
                                selectedTab = index;
                                setState(() {});
                              }),
                            );
                          },
                        ),
                        getSelectedTabComponent(),
                      ],
                    ),
                  ),
                ),
              );
          }
          return Container();
        }),
      ),
    );
  }
}
