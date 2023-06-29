import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_form.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';

import 'package:mobile/models/product.dart';
import 'package:mobile/routes.dart';

import 'package:mobile/components/widget_app_scroll.dart';
import 'package:mobile/components/widget_text_form_field.dart';
import 'package:mobile/components/widget_two_button.dart';
import 'package:mobile/utils/widgets.dart';

class RegisterProduct extends StatefulWidget {
  const RegisterProduct({Key? key}) : super(key: key);

  @override
  State<RegisterProduct> createState() => _RegisterProductState();
}

class _RegisterProductState extends State<RegisterProduct> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool? _isChecked = false;

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
      title: AppLocalizations.of(context)!.registerProduct,
      icon1: IconButton(
        onPressed: () => AppRoutes.goToMenu(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      children: <Widget>[
        _buildFormSection(),
        const SizedBox(height: 25),
        _buildConfirmationButtons(),
      ],
    );
  }

  _buildFormSection() {
    return WidgetForm(
      formKey: _formKey,
      children: <Widget>[
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.name,
          keyboardType: TextInputType.text,
          onSaved: (value) => _formData["name"] = value!,
          validator: (value) {
            if (value == null || value.isEmpty) return "Valor não pode ser vazio";
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.price,
          keyboardType: TextInputType.number,
          onSaved: (value) => _formData["price"] = value!,
          validator: (value) {
            if (value == null || value.isEmpty) return "Valor não pode ser vazio";
            if (double.tryParse(value) == null) return "O preço deve conter apenas valores numericos";
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.description,
          keyboardType: TextInputType.text,
          onSaved: (value) => _formData["description"] = value!,
          validator: (value) {
            if (value == null || value.isEmpty) return "Valor não pode ser vazio";
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.image,
          keyboardType: TextInputType.text,
          onSaved: (value) => _formData["image"] = value!,
        ),
        FormBuilderCheckbox(
          name: "avaliable",
          title: Text(AppLocalizations.of(context)!.avaliableInMenu, style: const TextStyle(fontSize: 17)),
          initialValue: false,
          onChanged: (value) => setState(() {
            _isChecked = value!;
          }),
        ),
      ],
    );
  }

  Widget _buildConfirmationButtons() {
    return WidgetTwoButton(
      textLeft: AppLocalizations.of(context)!.create,
      textRight: AppLocalizations.of(context)!.back,
      buttonLeft: () {
        try {
          _formKey.currentState!.save();
          if (!_formKey.currentState!.validate()) return;
          if (!context.mounted) return;

          Product product = Product(
            id: null,
            image: _formData['image'].toString(),
            name: _formData['name'].toString(),
            description: _formData['description'].toString(),
            price: double.parse(_formData['price'].toString()),
            available: _isChecked!,
          );

          ApiService.productRegister(product);
          WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.productRegisterSucess);
        } catch (e) {
          if (e is TimeoutException) {
            WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.errorServerDown);
          } else {
            WidgetUtils.showMessageSnackBar(_formKey.currentContext!, e.toString());
          }
        }
      },
      buttonRight: () => AppRoutes.goToMenu(context),
    );
  }
}
