import 'package:flutter/material.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_row.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/user.dart';

import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';

import 'package:mobile/components/widget_app_bar.dart';

import 'package:mobile/routes.dart';

class ManagementEmployees extends StatefulWidget {
  const ManagementEmployees({Key? key}) : super(key: key);

  @override
  State<ManagementEmployees> createState() => _ManagementEmployeesState();
}

class _ManagementEmployeesState extends State<ManagementEmployees> {
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = ApiService.user;

    if (user == null) {
      return Scaffold(
        body: Center(
            child: WidgetColumn(
          children: [
            const WidgetText(text: 'Erro: Usuário não encontrado.'),
            const SizedBox(height: 25),
            WidgetElevatedButton(
              text: AppLocalizations.of(context)!.back,
              onPressed: () => AppRoutes.goToConnect(context),
            )
          ],
        )),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<List<User>>(
        future: ApiService.usersAdminGet(),
        builder: (context, snapshot) {
          if (_isMounted) {
            if (snapshot.hasData) {
              return _buildProductListView(snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(child: Text(AppLocalizations.of(context)!.errorLoadingUsers));
            }
            return const Center(child: CircularProgressIndicator());
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildProductListView(List<User> users) {
    return Center(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: users.length,
        itemBuilder: (context, index) {
          if (users[index].username == ApiService.user!.username) return Container();

          return TextButton(
            onPressed: () {
              if (_isMounted) {
                AppRoutes.goToUpdateUser(context, arguments: users[index]);
              }
            },
            child: WidgetRow(
              children: [
                Expanded(
                  child: WidgetColumn(
                    children: [
                      const SizedBox(height: 25),
                      WidgetText(text: users[index].name),
                      WidgetText(text: _textAcess(users[index].acess)),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                /*WidgetContainer(
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: WidgetText(text: AppLocalizations.of(context)!.youSure),
                            content: WidgetText(text: AppLocalizations.of(context)!.areYouSure),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: WidgetText(text: AppLocalizations.of(context)!.no),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await ApiService.userDelete(users[index]);
                                  setState(() {});
                                  //onPressedDeleteItem();
                                  Navigator.of(context).pop();
                                  WidgetUtils.showMessageSnackBar(context, AppLocalizations.of(context)!.deleteSucess);
                                },
                                child: WidgetText(text: AppLocalizations.of(context)!.yes),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
                const SizedBox(width: 50),*/
              ],
            ),
          );
        },
      ),
    );
  }

  String _textAcess(int a) {
    switch (a) {
      case 2:
        return AppLocalizations.of(context)!.acess2;
      case 1:
        return AppLocalizations.of(context)!.acess1;
      default:
        return AppLocalizations.of(context)!.acess0;
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return WidgetAppBar(
      title: AppLocalizations.of(context)!.managementEmployees,
      icon1: IconButton(
        onPressed: () {
          if (_isMounted) AppRoutes.goToMain(context);
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      icon2: IconButton(
        onPressed: () {
          if (_isMounted) AppRoutes.goToRegister(context);
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
