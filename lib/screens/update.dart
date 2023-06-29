import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_row.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';

import 'package:mobile/routes.dart';

import 'package:mobile/components/widget_app_scroll.dart';
import 'package:mobile/components/widget_two_button.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/utils/widgets.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late final List<String> opcoes = [
    AppLocalizations.of(context)!.acess0,
    AppLocalizations.of(context)!.acess1,
    AppLocalizations.of(context)!.acess2,
  ];
  late String _opcaoSelecionada = opcoes[0];

  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)?.settings.arguments as User?;

    if (user == null) {
      return Scaffold(
        body: Center(
            child: WidgetColumn(
          children: [
            const WidgetText(text: 'Erro: Funcionario não encontrado.'),
            const SizedBox(height: 25),
            WidgetElevatedButton(
              text: AppLocalizations.of(context)!.back,
              onPressed: () => AppRoutes.goToManagementEmployees(context),
            )
          ],
        )),
      );
    }

    return WidgetAppScroll(
      title: user.name,
      children: <Widget>[
        _buildProductDescription(user),
        const SizedBox(height: 25),
        buildDropdownButton(),
        const SizedBox(height: 25),
        _buildConfirmationButtons(user),
      ],
    );
  }

  Widget _buildProductDescription(User user) {
    return WidgetRow(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.account_box, size: 75),
            WidgetText(
              text: Utils.shortenText(user.name),
              style: const TextStyle(fontSize: 30),
            ),
            WidgetText(text: user.email),
            WidgetText(text: user.phone),
            WidgetText(text: user.address),
            WidgetText(text: _textAcess(user.acess)),
            const SizedBox(height: 25),
          ],
        ),
      ],
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

  Widget buildDropdownButton() {
    return WidgetRow(
      children: [
        WidgetText(text: AppLocalizations.of(context)!.selectAccessLevel),
        DropdownButton(
          value: _opcaoSelecionada,
          items: opcoes.map((opcao) {
            return DropdownMenuItem(
              value: opcao,
              child: Text(opcao),
            );
          }).toList(),
          onChanged: (novaOpcaoSelecionada) {
            setState(() {
              _opcaoSelecionada = novaOpcaoSelecionada!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildConfirmationButtons(User user) {
    return WidgetTwoButton(
      textLeft: AppLocalizations.of(context)!.update,
      textRight: AppLocalizations.of(context)!.back,
      buttonLeft: () => _buttonUpdate(user),
      buttonRight: () => AppRoutes.goToManagementEmployees(context),
    );
  }

  void _buttonUpdate(User user) async {
    try {
      int a = int.parse(_convertAccess(_opcaoSelecionada));
      user.setAcess = a;
      final response = await ApiService.userUpdateStatus(user);

      if (!context.mounted) return;
      if (response) {
        setState(() {});
        WidgetUtils.showMessageSnackBar(context, AppLocalizations.of(context)!.updateSucess);
      } else {
        WidgetUtils.showMessageSnackBar(context, AppLocalizations.of(context)!.errorUpdate);
      }
    } catch (e) {
      if (e is TimeoutException) {
        WidgetUtils.showMessageSnackBar(context, AppLocalizations.of(context)!.errorServerDown);
      } else {
        WidgetUtils.showMessageSnackBar(context, e.toString());
      }
    }
  }

  _convertAccess(String access) {
    if (access == AppLocalizations.of(context)!.acess2) {
      return '2';
    }
    if (access == AppLocalizations.of(context)!.acess1) {
      return '1';
    }
    return '0';
  }
}
