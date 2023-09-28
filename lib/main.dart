import 'package:calkuta/screens/dash.dart';
import 'package:calkuta/screens/trans.dart';
import 'package:calkuta/screens/upload_image.dart';
import 'package:calkuta/util/database_screen.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:calkuta/screens/dashboard_screen.dart';
import 'package:calkuta/screens/login_screen.dart';
import 'package:calkuta/screens/update_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calkuta',
      theme: ThemeData(
        primaryColor: MyColor.mytheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DashScreen(),
        '/login': (context) => LoginScreen(),
        //'/dash': (context) => DashScreen(),
        '/dashboard': (context) => DashboardScreen(),

        '/imgupload': (context) => ImageUploaderWidget(),
        '/trans': (context) => TransactionList(),
        '/update': (context) => UpdateScreen(),
        '/databasescreen': (context) => DatabaseScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
