import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_form.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';

import 'package:mobile/models/product.dart';
import 'package:mobile/routes.dart';

import 'package:mobile/components/widget_app_scroll.dart';
import 'package:mobile/components/widget_text_form_field.dart';
import 'package:mobile/components/widget_two_button.dart';
import 'package:mobile/components/widget_imagem.dart';
import 'package:mobile/utils/widgets.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({Key? key}) : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool? _isChecked;

  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)?.settings.arguments as Product?;

    if (product == null) {
      return Scaffold(
        body: Center(
            child: WidgetColumn(
          children: [
            const WidgetText(text: 'Erro: produto não encontrado.'),
            const SizedBox(height: 25),
            WidgetElevatedButton(
              text: AppLocalizations.of(context)!.back,
              onPressed: () => AppRoutes.goToMenu(context),
            )
          ],
        )),
      );
    }

    return WidgetAppScroll(
      title: product.name,
      children: <Widget>[
        _buildProductDescription(product),
        const SizedBox(height: 25),
        _buildFormSection(product),
        const SizedBox(height: 25),
        _buildConfirmationButtons(product),
      ],
    );
  }

  Widget _buildProductDescription(Product product) {
    if (!RegExp(r"(http|https)://").hasMatch(product.image)) {
      return FutureBuilder<Product>(
        future: ApiService.productGet(product.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            product = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WidgetImage(
                  url: product.image,
                  width: 300,
                  height: 300 / 1.5,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetImage(
            url: product.image,
            width: 300,
            height: 300 / 1.5,
          ),
        ],
      );
    }
  }

  _buildFormSection(Product product) {
    return WidgetForm(
      formKey: _formKey,
      children: <Widget>[
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.name,
          keyboardType: TextInputType.text,
          onSaved: (value) => _formData["name"] = value!,
          initialValue: product.name,
          validator: (value) {
            if (value == null || value.isEmpty) return "Valor não pode ser vazio";
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.price,
          keyboardType: TextInputType.number,
          onSaved: (value) => _formData["price"] = value!,
          initialValue: product.price.toString(),
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
          initialValue: product.description,
          validator: (value) {
            if (value == null || value.isEmpty) return "Valor não pode ser vazio";
            return null;
          },
        ),
        WidgetTextFormField(
          title: AppLocalizations.of(context)!.image,
          keyboardType: TextInputType.text,
          onSaved: (value) => _formData["image"] = value!,
          initialValue: product.image.substring(product.image.lastIndexOf("/") + 1),
        ),
        FormBuilderCheckbox(
          name: "avaliable",
          title: Text(AppLocalizations.of(context)!.avaliableInMenu, style: const TextStyle(fontSize: 17)),
          initialValue: product.available,
          onChanged: (value) => setState(() {
            _isChecked = value!;
          }),
        ),
      ],
    );
  }

  Widget _buildConfirmationButtons(Product product) {
    return WidgetTwoButton(
      textLeft: AppLocalizations.of(context)!.update,
      textRight: AppLocalizations.of(context)!.back,
      buttonLeft: () => setState(() {
        try {
          _formKey.currentState!.save();
          if (!_formKey.currentState!.validate()) return;
          if (!context.mounted) return;

          product.update(_formData, _isChecked, context);
          ApiService.productUpdate(product);
          WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.updateSucess);
        } catch (e) {
          if (e is TimeoutException) {
            WidgetUtils.showMessageSnackBar(_formKey.currentContext!, AppLocalizations.of(_formKey.currentContext!)!.errorServerDown);
          } else {
            WidgetUtils.showMessageSnackBar(_formKey.currentContext!, e.toString());
          }
        }
      }),
      buttonRight: () => AppRoutes.goToMenu(context),
    );
  }
}
