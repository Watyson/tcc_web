import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mobile/routes.dart';
import 'package:mobile/screens/connect.dart';
import 'package:mobile/screens/management_employees.dart';
import 'package:mobile/screens/management_main.dart';
import 'package:mobile/screens/management_sales.dart';
import 'package:mobile/screens/register_product.dart';
import 'package:mobile/screens/sales.dart';
import 'package:mobile/screens/update.dart';
import 'package:mobile/screens/update_product.dart';
import 'package:mobile/screens/management_menu.dart';
import 'package:mobile/screens/profile.dart';
import 'package:mobile/screens/register.dart';
import 'package:mobile/utils/app_localizations/app_localizations_extension.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      theme: ThemeData.light(),
      initialRoute: AppRoutes.connect,
      routes: {
        AppRoutes.connect: (_) => const Connect(),
        AppRoutes.managementMenu: (_) => const Menu(),
        AppRoutes.managementMain: (_) => const Main(),
        AppRoutes.profile: (_) => const Profile(),
        AppRoutes.updateProduct: (_) => const UpdateProduct(),
        AppRoutes.registerProduct: (_) => const RegisterProduct(),
        AppRoutes.managementEmployees: (_) => const ManagementEmployees(),
        AppRoutes.managementSales: (_) => const ManagementSales(),
        AppRoutes.updateUser: (_) => const UpdateUser(),
        AppRoutes.register: (_) => const Register(),
        AppRoutes.sales: (_) => const Sales(),
      },
    );
  }
}
