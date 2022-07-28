import 'package:beamer/beamer.dart';
import 'package:expertis/models/shop_model.dart';
import 'package:expertis/routes/home_routes.dart';
import 'package:expertis/routes/routes_name.dart';
import 'package:expertis/screens/create_shop_screen.dart';
import 'package:expertis/screens/BMDashboardScreen.dart';
import 'package:expertis/screens/review_shop_screen.dart';
import 'package:expertis/screens/shop_details_screen.dart';
import 'package:expertis/screens/BMSplashScreen.dart';
import 'package:expertis/screens/add_service_screen.dart';
import 'package:expertis/screens/book_appointment_screen.dart';
import 'package:expertis/screens/owner_dashboard_screen.dart';
import 'package:expertis/screens/shop_info_edit_screen.dart';
import 'package:expertis/view_model/shop_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ShopsLocation extends BeamLocation<BeamState> {
  @override
  Widget builder(BuildContext context, Widget navigator) =>
      ChangeNotifierProvider<ShopViewModel>.value(
        value: ShopViewModel(),
        child: navigator,
      );
  @override
  List<String> get pathPatterns => [
        RoutesName.allShops,
        RoutesName.viewShop,
        RoutesName.ownerDashboard,
        RoutesName.shopServices,
        RoutesName.shopAppointments,
        RoutesName.shopDetails,
        RoutesName.aboutShop,
        RoutesName.shopPortfolio,
        RoutesName.shopServicesById,
        RoutesName.aboutShop,
        RoutesName.shopReviewsById,
        RoutesName.reviewShop,
        RoutesName.createShop,
        RoutesName.updateShopInfo,
        RoutesName.updateShopContact,
        RoutesName.createService,
        RoutesName.updateService,
        RoutesName.ownerDashboard,
        RoutesName.bookAppointment,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      // ...HomeLocation().buildPages(context, state),
      if (state.uri.pathSegments.contains('shops'))
        BeamPage(
          key: const ValueKey('shops'),
          title: 'Shops',
          child: BMDashboardScreen(),
        ),
      if (state.uri.pathSegments.contains('shop') &&
          state.uri.pathSegments.contains('create'))
        const BeamPage(
          key: ValueKey('create_shop'),
          title: 'Create Shop',
          child: CreateShopScreen(),
        ),
      if (state.uri.pathSegments.contains('shop') &&
          state.uri.pathSegments.contains('update') &&
          state.uri.pathSegments.contains('info'))
        BeamPage(
          key: ValueKey('create_shop'),
          title: 'Create Shop',
          child: ShopInfoEditScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
            shop: data != null ? data as ShopModel : null,
          ),
        ),

      if (state.uri.pathSegments.contains('book') &&
          state.pathParameters.containsKey('shopId'))
        BeamPage(
          key: const ValueKey(RoutesName.bookAppointment),
          title: 'book ${state.pathParameters['shopId']}',
          child: BookAppointmentScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
          ),
        ),
      if (state.uri.pathSegments.contains('view') &&
          state.pathParameters.containsKey('shopId'))
        BeamPage(
          key: const ValueKey(RoutesName.viewShop),
          title: ' view ${state.pathParameters['shopId']}',
          child: ShopViewScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
          ),
        ),
      if (state.uri.pathSegments.contains('services') &&
          state.pathParameters.containsKey('shopId'))
        BeamPage(
          key: const ValueKey(RoutesName.shopServicesById),
          title: ' ${state.pathParameters['shopId']} services',
          child: ShopViewScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
            selectedTab: 0,
          ),
        ),
      if (state.uri.pathSegments.contains('portfolio') &&
          state.pathParameters.containsKey('shopId'))
        BeamPage(
          key: const ValueKey(RoutesName.shopPortfolio),
          title: '${state.pathParameters['shopId']} portfolio',
          child: ShopViewScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
            selectedTab: 1,
          ),
        ),
      if (state.uri.pathSegments.contains('about') &&
          state.pathParameters.containsKey('shopId'))
        BeamPage(
          key: const ValueKey(RoutesName.aboutShop),
          title: ' about ${state.pathParameters['shopId']}',
          child: ShopViewScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
            selectedTab: 2,
          ),
        ),
      if (state.uri.pathSegments.contains('reviews') &&
          state.pathParameters.containsKey('shopId'))
        BeamPage(
          key: const ValueKey(RoutesName.shopReviewsById),
          title: ' ${state.pathParameters['shopId']} reviews',
          child: ShopViewScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
            selectedTab: 3,
          ),
        ),
      if (state.uri.pathSegments.contains('write-review') &&
          state.pathParameters.containsKey('shopId'))
        BeamPage(
          key: const ValueKey(RoutesName.reviewShop),
          title: ' Review ${state.pathParameters['shopId']}',
          child: WriteReviewScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
          ),
        ),

      // Services

      if (state.uri.pathSegments.contains('service') &&
          state.uri.pathSegments.contains('add'))
        const BeamPage(
          key: ValueKey(RoutesName.createService),
          title: 'Add Service',
          child: CreateServiceScreen(),
        ),
      if (state.uri.pathSegments.contains('shop') &&
          state.uri.pathSegments.contains('dashboard'))
        BeamPage(
          key: const ValueKey(RoutesName.ownerDashboard),
          title: 'Shop Dashboard',
          child: ShopOwnerDashboardScreen(
            shopId: state.pathParameters['shopId'] ?? 'null',
          ),
        ),
      if (state.uri.pathSegments.contains('shop') &&
          state.uri.pathSegments.contains('services'))
        BeamPage(
          key: const ValueKey(RoutesName.shopServices),
          title: 'Shop services',
          child: ShopOwnerDashboardScreen(
              shopId: state.pathParameters['shopId'] ?? 'null'),
        ),
      if (state.uri.pathSegments.contains('shop') &&
          state.uri.pathSegments.contains('appointments'))
        BeamPage(
          key: const ValueKey(RoutesName.shopAppointments),
          title: 'Shop appointments',
          child: ShopOwnerDashboardScreen(
              shopId: state.pathParameters['shopId'] ?? 'null'),
        ),
      // if (state.uri.pathSegments.contains('shop') &&
      //     state.uri.pathSegments.contains('info'))
      //   BeamPage(
      //     key: const ValueKey(RoutesName.shopDetails),
      //     title: 'Shop Info',
      //     child: ShopOwnerDashboardScreen(
      //         shopId: state.pathParameters['shopId'] ?? 'null'),
      //   ),

      if (state.pathParameters.containsKey('serviceId') &&
          state.uri.pathSegments.contains('update'))
        BeamPage(
          key: ValueKey('Update ${state.pathParameters['serviceId']}'),
          title: 'Update ${state.pathParameters['serviceId']}',
          child: ShopViewScreen(
            shopId: state.pathParameters['serviceId'] ?? 'null',
          ),
        ),
    ];
  }
}
