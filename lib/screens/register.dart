import 'package:flutter/material.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_row.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/utils/api_service.dart';
import 'dart:async';

import 'package:mobile/utils/app_localizations/app_localizations.dart';
import 'package:mobile/utils/converters/user.dart';
import 'package:mobile/utils/validator.dart';
import 'package:mobile/utils/widgets.dart';

import 'package:mobile/components/widget_app_scroll.dart';
import 'package:mobile/components/widget_form.dart';
import 'package:mobile/components/widget_text_form_field.dart';
import 'package:mobile/components/widget_two_button.dart';

import 'package:mobile/routes.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  late final List<String> opcoes = [
    AppLocalizations.of(context)!.acess0,
    AppLocalizations.of(context)!.acess1,
    AppLocalizations.of(context)!.acess2,
  ];
  late String _opcaoSelecionada = opcoes[0];

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

    return WidgetAppScroll(
      title: AppLocalizations.of(context)!.register,
      icon1: IconButton(
        onPressed: () => AppRoutes.goToManagementEmployees(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      children: <Widget>[
        WidgetForm(
          formKey: _formKey,
          children: [
            WidgetTextFormField(
              title: AppLocalizations.of(context)!.username,
              validator: (value) => Validator.username(context, value!),
              onSaved: (value) => _formData["username"] = value!,
            ),
            WidgetTextFormField(
              title: AppLocalizations.of(context)!.password,
              obscureText: true,
              validator: (value) => Validator.password(context, value!, null),
              onSaved: (value) => _formData["password"] = value!,
              onChanged: (value) => _formData["password"] = value!,
            ),
            WidgetTextFormField(
              title: AppLocalizations.of(context)!.repeatPassword,
              obscureText: true,
              validator: (value) => Validator.password(context, value!, _formData["password"]),
              onSaved: (value) => _formData["repeat_password"] = value!,
            ),
            WidgetTextFormField(
              title: AppLocalizations.of(context)!.name,
              validator: (value) => Validator.name(context, value!),
              onSaved: (value) => _formData["name"] = value!,
            ),
            WidgetTextFormField(
              title: AppLocalizations.of(context)!.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validator.email(context, value!),
              onSaved: (value) => _formData["email"] = value!,
            ),
            WidgetTextFormField(
              title: AppLocalizations.of(context)!.phone,
              keyboardType: TextInputType.phone,
              validator: (value) => Validator.phone(context, value!),
              onSaved: (value) => _formData["phone"] = value!,
            ),
            WidgetTextFormField(
              title: AppLocalizations.of(context)!.address,
              keyboardType: TextInputType.streetAddress,
              validator: (value) => Validator.address(context, value!),
              onSaved: (value) => _formData["address"] = value!,
            ),
            const SizedBox(height: 15),
            buildDropdownButton(),
          ],
        ),
        const SizedBox(height: 64),
        WidgetTwoButton(
          textLeft: AppLocalizations.of(context)!.register,
          textRight: AppLocalizations.of(context)!.back,
          buttonLeft: _register,
          buttonRight: () => AppRoutes.goToManagementEmployees(context),
        ),
      ],
    );
  }

  void _register() async {
    try {
      _formKey.currentState!.save();
      if (_formKey.currentState?.validate() == false) return;

      User user = UserConverter.fromJson(_formData);
      int a = int.parse(_convertAccess(_opcaoSelecionada));
      user.setAcess = a;

      final response = await ApiService.userRegister(user);

      if (response != 201) {
        if (response == 422) throw AppLocalizations.of(_formKey.currentContext!)!.errorCreateAccount1;
        throw AppLocalizations.of(_formKey.currentContext!)!.errorCreateAccount;
      }

      _formData.clear();
      WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.registerSucess);
    } catch (e) {
      if (e is TimeoutException) {
        WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.errorServerDown);
      } else {
        WidgetUtils.showMessageSnackBar(_formKey.currentContext!, e.toString());
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
}
