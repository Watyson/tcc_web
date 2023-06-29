import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';

import 'package:mobile/utils/app_localizations/app_localizations.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/utils/validator.dart';
import 'package:mobile/utils/widgets.dart';
import 'package:mobile/utils/api_service.dart';

import 'package:mobile/components/widget_app_scroll.dart';
import 'package:mobile/components/widget_form.dart';
import 'package:mobile/components/widget_row.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/components/widget_text_form_field.dart';
import 'package:mobile/components/widget_two_button.dart';

import 'package:mobile/models/user.dart';

import 'package:mobile/routes.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

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
      title: AppLocalizations.of(context)!.profile,
      icon1: IconButton(
        onPressed: () {
          AppRoutes.goToMain(context);
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      children: <Widget>[
        WidgetRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buttonLogout(),
            _buttonChangeLanguage(),
          ],
        ),
        _buildUserInfoSection(user),
        _buildFormSection(),
        const SizedBox(height: 30),
        WidgetTwoButton(
          textLeft: AppLocalizations.of(context)!.update,
          textRight: AppLocalizations.of(context)!.back,
          buttonLeft: () => _atualizar(user),
          buttonRight: () => AppRoutes.goToMain(context),
        ),
      ],
    );
  }

  Widget _buttonChangeLanguage() {
    final appLocalizations = AppLocalizations.of(context)!;

    return TextButton(
      onPressed: () => setState(() {
        appLocalizations.changeLanguage();
      }),
      child: WidgetText(
        text: appLocalizations.getLanguage(),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _buttonLogout() {
    return TextButton(
      onPressed: () => setState(() {
        try {
          ApiService.userLogout();
          AppRoutes.goToConnect(_formKey.currentContext!);
        } catch (e) {
          if (e is TimeoutException) {
            WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.errorServerDown);
          } else {
            WidgetUtils.showMessageSnackBar(_formKey.currentContext!, e.toString());
          }
        }
      }),
      child: WidgetText(
        text: AppLocalizations.of(context)!.logout,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _buildUserInfoSection(User user) {
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

  _buildFormSection() {
    return WidgetForm(
      formKey: _formKey,
      children: <Widget>[
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.newEmail,
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) => _formData["email"] = value!,
          validator: (value) {
            if (value != "") return Validator.email(context, value!);
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.newAddress,
          keyboardType: TextInputType.streetAddress,
          onSaved: (value) => _formData["address"] = value!,
          validator: (value) {
            if (value != "") return Validator.address(context, value!);
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.newPhone,
          keyboardType: TextInputType.phone,
          onSaved: (value) => _formData["phone"] = value!,
          validator: (value) {
            if (value != "") return Validator.phone(context, value!);
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.newPassword,
          keyboardType: TextInputType.visiblePassword,
          onSaved: (value) => _formData["password"] = value!,
          onChanged: (value) => _formData["password"] = value!,
          validator: (value) {
            if (value != "") return Validator.password(context, value!, null);
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.newRepeatPassword,
          onSaved: (value) => _formData["repeat_password"] = value!,
          obscureText: true,
          validator: (v) {
            if (v != "") return Validator.password(context, v!, _formData["password"]);
            return null;
          },
        ),
      ],
    );
  }

  void _atualizar(User user) async {
    try {
      _formKey.currentState!.save();
      if (!_formKey.currentState!.validate()) return;
      if (!context.mounted) return;

      user.update(_formData, context);
      final response = await ApiService.userUpdate(user);

      if (response) {
        setState(() {
          _formKey.currentState!.reset();
        });
        WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.updateSucess);
      } else {
        WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.errorUpdate);
      }
    } catch (e) {
      if (e is TimeoutException) {
        WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.errorServerDown);
      } else {
        WidgetUtils.showMessageSnackBar(_formKey.currentContext!, e.toString());
      }
    }
  }
}
