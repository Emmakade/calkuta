import 'package:flutter/material.dart';

import '../screens/all_contributors.dart';
import '../screens/dash_list.dart';
import '../screens/dash_menu_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/trans.dart';
import '../screens/update_screen.dart';
import '../screens/upload_image.dart';
import '../util/database_screen.dart';
import 'route_names.dart';

Map<String, WidgetBuilder> appRoutes = {
  RouteNames.dashMenuScreen: (context) => const DashMenuScreen(),
  RouteNames.login: (context) => LoginScreen(),
  RouteNames.dashboard: (context) => const DashboardScreen(),
  RouteNames.imageUpload: (context) => ImageUploaderWidget(),
  RouteNames.transactionList: (context) => const TransactionList(),
  RouteNames.update: (context) => UpdateScreen(),
  RouteNames.database: (context) => const DatabaseScreen(),
  RouteNames.dashList: (context) => const DashList(),
  RouteNames.allContributors: (context) => const AllContributors(),
};
