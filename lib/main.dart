import 'package:calkuta/screens/dash_menu_screen.dart';
import 'package:calkuta/screens/trans.dart';
import 'package:calkuta/screens/upload_image.dart';
import 'package:calkuta/util/database_screen.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:calkuta/screens/dashboard_screen.dart';
import 'package:calkuta/screens/login_screen.dart';
import 'package:calkuta/screens/update_screen.dart';
import 'package:flutter/services.dart';

import 'routes/app_routes.dart';
import 'routes/route_names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calkuta',
      theme: ThemeData(
        primaryColor: MyColor.mytheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: RouteNames.dashMenuScreen,
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Center(child: Text(details.exceptionAsString()));
        };
        return child!;
      },
    );
  }
}
