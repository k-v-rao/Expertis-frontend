import 'package:beamer/beamer.dart';
import 'package:expertis/data/response/status.dart';
import 'package:expertis/models/shop_model.dart';
import 'package:expertis/routes/appointment_routes.dart';
import 'package:expertis/routes/home_routes.dart';
import 'package:expertis/routes/more_routes.dart';
import 'package:expertis/routes/routes_name.dart';
import 'package:expertis/routes/search_routes.dart';

import 'package:expertis/screens/BMPurchaseMoreScreen.dart';
import 'package:expertis/screens/admin_dashboard_home.dart';
import 'package:expertis/screens/owner_dashboard_home_screen.dart';
import 'package:expertis/screens/services_home_screeen.dart';
import 'package:expertis/screens/shop_appointments_home_screen.dart';
import 'package:expertis/screens/shop_info_screen.dart';
import 'package:expertis/utils/assets.dart';
import 'package:expertis/utils/utils.dart';
import 'package:expertis/view_model/shop_view_model.dart';
import 'package:expertis/view_model/user_view_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../fragments/BMAppointmentFragment.dart';
import '../fragments/BMHomeFragment.dart';
import '../fragments/BMMoreFragment.dart';
import '../main.dart';
import '../models/BMDashboardModel.dart';
import '../utils/BMColors.dart';
import '../utils/BMDataGenerator.dart';

class ShopOwnerDashboardScreen extends StatefulWidget {
  bool flag = false;
  String? shopId;
  int tabNo;

  ShopOwnerDashboardScreen({
    super.key,
    required this.shopId,
    this.tabNo = 0,
  });

  @override
  ShopOwnerDashboardScreenState createState() =>
      ShopOwnerDashboardScreenState();
}

class ShopOwnerDashboardScreenState extends State<ShopOwnerDashboardScreen> {
  List<BMDashboardModel> list = getShopOwnerDashboardList();
  final shopViewModel = ShopViewModel();

  int selectedTab = 0;
  @override
  void initState() {
    setStatusBarColor(appStore.isDarkModeOn
        ? appStore.scaffoldBackground!
        : bmLightScaffoldBackgroundColor);
    super.initState();
    setState(() {
      selectedTab = widget.tabNo;
    });
    if (widget.shopId == null) {
      UserViewModel.getUser().then((value) =>
          {shopViewModel.fetchSelectedShopDataApi(value.shop?.first ?? '')});
    } else {
      shopViewModel.fetchSelectedShopDataApi(widget.shopId ?? "");
    }
  }

  Widget getFragment() {
    if (selectedTab == 0) {
      return ShopDashBoardHomeScreen();
    } else if (selectedTab == 1) {
      return ServicesHomeScreen(shopId: widget.shopId);
    } else if (selectedTab == 2) {
      return ShopAppointmentsHomeScreen(shopId: widget.shopId);
    } else if (selectedTab == 3) {
      return ShopInfoScreen();
    }
    return ShopDashBoardHomeScreen();
  }

  void getFragmentNo(selectedTab) {
    if (selectedTab == 0) {
      return Beamer.of(context).beamToNamed(RoutesName.ownerDashboardWithId(
        widget.shopId,
      ));
    } else if (selectedTab == 1) {
      return Beamer.of(context)
          .beamToNamed(RoutesName.shopServicesWithId(widget.shopId));
    } else if (selectedTab == 2) {
      return Beamer.of(context)
          .beamToNamed(RoutesName.shopAppointmentsWithId(widget.shopId));
    } else if (selectedTab == 3) {
      return Beamer.of(context)
          .beamToNamed(RoutesName.shopDetailsWithId(widget.shopId));
    } else {
      return Beamer.of(context).beamToNamed(RoutesName.ownerDashboard);
    }
  }

  @override
  void dispose() {
    if (widget.flag) {
      setStatusBarColor(appStore.isDarkModeOn
          ? appStore.scaffoldBackground!
          : bmLightScaffoldBackgroundColor);
    } else {
      setStatusBarColor(Colors.transparent);
    }

    super.dispose();
  }

  Color getDashboardColor() {
    if (!appStore.isDarkModeOn) {
      if (selectedTab == 1 || selectedTab == 2 || selectedTab == 3) {
        return bmSecondBackgroundColorLight;
      } else {
        return bmLightScaffoldBackgroundColor;
      }
    } else {
      if (selectedTab == 1 || selectedTab == 2 || selectedTab == 3) {
        return bmSecondBackgroundColorDark;
      } else {
        return appStore.scaffoldBackground!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getDashboardColor(),
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size * 0.1,
        child: ChangeNotifierProvider<ShopViewModel>.value(
          value: shopViewModel,
          child: Consumer<ShopViewModel>(builder: (context, value, _) {
            switch (value.selectedShop.status) {
              case Status.LOADING:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case Status.ERROR:
                String error = value.selectedShop.message.toString();
                return Center(
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                );

              case Status.COMPLETED:
                ShopModel? shop = value.selectedShop.data;
                if (kDebugMode) {
                  print(shop!.toJson());
                }
                return Container(
                  color: bmPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FancyShimmerImage(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.2,
                        errorWidget: const Icon(
                          Icons.dangerous,
                          color: Colors.red,
                          size: 28,
                        ),
                        imageUrl: shop?.shopLogo ?? Assets.defaultShopImage,
                        boxFit: BoxFit.fill,
                      ).expand(flex: 1),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              shop?.shopName ?? "",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Switch(
                                  value: shop?.isOpen == true,
                                  onChanged: (value) {},
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                                8.width,
                                Text(
                                  shop?.isOpen == true
                                      ? "Open Now"
                                      : "Closed Now",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ]).paddingOnly(left: 10, right: 10).expand(flex: 3),
                      IconButton(
                        icon: Icon(
                          size: 30,
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Beamer.of(context).beamToNamed(RoutesName.home);
                        },
                      ).center().expand(flex: 1),
                    ],
                  ),
                );
              default:
                return Container();
            }
          }),
        ),
      ),
      body: getFragment(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            selectedTab = index;
          });
          getFragmentNo(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.cardColor,
        unselectedItemColor: bmPrimaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: selectedTab,
        items: list.map((e) {
          return BottomNavigationBarItem(
            label: e.label,
            icon: Image.asset(e.unSelectedIcon,
                height: 24, color: bmPrimaryColor),
            activeIcon:
                Image.asset(e.selectedIcon, height: 24, color: bmPrimaryColor),
          );
        }).toList(),
      ).cornerRadiusWithClipRRectOnly(topLeft: 32, topRight: 32),
    );
  }
}
