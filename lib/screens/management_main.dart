import 'package:flutter/material.dart';

import 'package:mobile/components/widget_app.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final size = const Size(250, 75);

  @override
  Widget build(BuildContext context) {
    return WidgetApp(
      showBar: false,
      children: <Widget>[
        SizedBox(
          child: WidgetElevatedButton(
            text: AppLocalizations.of(context)!.managementMenu,
            onPressed: () => AppRoutes.goToMenu(context),
            minimumSize: size,
          ),
        ),
        const SizedBox(height: 25, width: 2000),
        WidgetElevatedButton(
          text: AppLocalizations.of(context)!.managementSales,
          onPressed: () => AppRoutes.goToManagementSales(context),
          minimumSize: size,
        ),
      ],
    );
  }
}
