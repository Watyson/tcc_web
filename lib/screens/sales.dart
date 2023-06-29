import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_row.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/cart_item.dart';
import 'package:mobile/models/historic_update.dart';
import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';

import 'package:mobile/routes.dart';

import 'package:mobile/components/widget_app_scroll.dart';
import 'package:mobile/components/widget_two_button.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/utils/widgets.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  late final List<String> opcoes = [
    AppLocalizations.of(context)!.underReview,
    AppLocalizations.of(context)!.inPreparation,
    AppLocalizations.of(context)!.onTheWay,
    AppLocalizations.of(context)!.delivered,
    AppLocalizations.of(context)!.canceled,
  ];
  late String _opcaoSelecionada = opcoes[0];

  @override
  Widget build(BuildContext context) {
    List<CartItem>? list = ModalRoute.of(context)?.settings.arguments as List<CartItem>?;

    if (list == null) {
      return Scaffold(
        body: Center(
            child: WidgetColumn(
          children: [
            const WidgetText(text: 'Erro: Compras não encontradas.'),
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
      title: list[0].idPurchase.toString().padLeft(10, '0'),
      icon1: IconButton(
        onPressed: () => AppRoutes.goToManagementSales(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      children: <Widget>[
        buildDropdownButton(),
        const SizedBox(height: 25),
        _buildConfirmationButtons(list),
        const SizedBox(height: 25),
        const Divider(color: Colors.black, thickness: 1),
        const WidgetText(text: "Descrição dos produtos no pedido"),
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 25),
        _buildProductDescription(list),
      ],
    );
  }

  Widget _buildProductDescription(List<CartItem> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((item) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetRow(
              children: [
                WidgetText(
                  text: Utils.shortenText(item.name),
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 5),
            WidgetText(text: "${AppLocalizations.of(context)!.date}: ${formatDate(item.date)}"),
            const SizedBox(height: 5),
            WidgetText(text: "${AppLocalizations.of(context)!.description}: ${item.description}"),
            const SizedBox(height: 5),
            WidgetText(text: "${AppLocalizations.of(context)!.observations}: ${item.observation}"),
            const SizedBox(height: 5),
            WidgetRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WidgetText(text: "${AppLocalizations.of(context)!.quantity}: ${item.quantity}"),
                WidgetText(text: "${AppLocalizations.of(context)!.totalPrice}: ${item.totalPrice}"),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(dateTime);
  }

  Widget buildDropdownButton() {
    return WidgetRow(
      children: [
        WidgetText(text: AppLocalizations.of(context)!.selectDeliveredLevel),
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

  Widget _buildConfirmationButtons(List<CartItem> list) {
    return WidgetTwoButton(
      textLeft: AppLocalizations.of(context)!.update,
      textRight: AppLocalizations.of(context)!.back,
      buttonLeft: () => _buttonUpdate(list),
      buttonRight: () => AppRoutes.goToManagementSales(context),
    );
  }

  void _buttonUpdate(List<CartItem> list) async {
    try {
      int a = int.parse(_convertAccess(_opcaoSelecionada));
      var update = HistoricUpdate(list[0].idPurchase, a, list[0].paymentType);

      final response = await ApiService.historicUpdate(update);

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
    if (access == AppLocalizations.of(context)!.canceled) {
      return '4';
    }
    if (access == AppLocalizations.of(context)!.delivered) {
      return '3';
    }
    if (access == AppLocalizations.of(context)!.onTheWay) {
      return '2';
    }
    if (access == AppLocalizations.of(context)!.inPreparation) {
      return '1';
    }
    return '0';
  }
}
