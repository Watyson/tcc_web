import 'package:flutter/material.dart';

class AppRoutes {
  static const String connect = "/connect";
  static const String managementMain = "/management_main";
  static const String managementMenu = "/management_menu";
  static const String updateProduct = "/updateProduct";
  static const String registerProduct = "/registerProduct";
  static const String managementEmployees = "/managementEmployees";
  static const String managementSales = "/managementSales";
  static const String updateUser = "/updateUser";
  static const String profile = "/profile";
  static const String register = "/register";
  static const String sales = "/sales";

  static void goToScreen(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  static void goToConnect(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, connect, arguments: arguments);
  }

  static void goToMenu(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, managementMenu, arguments: arguments);
  }

  static void goToMain(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, managementMain, arguments: arguments);
  }

  static void goToUpdateProduct(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, updateProduct, arguments: arguments);
  }

  static void goToRegisterProduct(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, registerProduct, arguments: arguments);
  }

  static void goToManagementEmployees(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, managementEmployees, arguments: arguments);
  }

  static void goToManagementSales(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, managementSales, arguments: arguments);
  }

  static void goToRegister(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, register, arguments: arguments);
  }

  static void goToProfile(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, profile, arguments: arguments);
  }

  static void goToUpdateUser(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, updateUser, arguments: arguments);
  }

    static void goToSales(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, sales, arguments: arguments);
  }
}
