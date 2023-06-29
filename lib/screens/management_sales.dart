import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_row.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/cart_item.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';
import 'package:mobile/components/widget_app_bar.dart';

class ManagementSales extends StatefulWidget {
  const ManagementSales({Key? key}) : super(key: key);

  @override
  State<ManagementSales> createState() => _ManagementSalesState();
}

class _ManagementSalesState extends State<ManagementSales> {
  bool _isMounted = false;
  late final List<String> _statusOptions = [
    AppLocalizations.of(context)!.underReview,
    AppLocalizations.of(context)!.inPreparation,
    AppLocalizations.of(context)!.onTheWay,
    AppLocalizations.of(context)!.delivered,
    AppLocalizations.of(context)!.canceled,
  ];
  late String _selectedStatus = _statusOptions[0];

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
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: _selectedStatus,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue ?? _statusOptions[0];
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<int, List<CartItem>>>(
              future: ApiService.getHistoric(),
              builder: (context, snapshot) {
                if (_isMounted) {
                  if (snapshot.hasData) {
                    return _buildProductListView(snapshot.data!);
                  } else if (snapshot.hasError) {
                    return Center(child: Text(AppLocalizations.of(context)!.errorLoadingProducts));
                  }
                  return const Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListView(Map<int, List<CartItem>> historic) {
    final keys = historic.keys.toList();
    final filteredKeys = keys.where((key) => historic[key]!.first.statusText(context) == _selectedStatus).toList();

    return Center(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: filteredKeys.length,
        itemBuilder: (context, index) {
          final key = filteredKeys[index];
          final List<CartItem>? items = historic[key];

          if (items == null) {
            return Container();
          }

          return TextButton(
            onPressed: () {
              if (_isMounted) {
                AppRoutes.goToSales(context, arguments: items);
              }
            },
            child: WidgetRow(
              children: [
                WidgetText(
                  text: items.first.idPurchase.toString().padLeft(10, '0'),
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(width: 50),
                WidgetColumn(
                  children: [
                    WidgetText(text: items.first.statusText(context)),
                    WidgetText(text: formatDate(items.first.date)),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(dateTime);
  }

  PreferredSizeWidget _buildAppBar() {
    return WidgetAppBar(
      title: AppLocalizations.of(context)!.managementSales,
      icon1: IconButton(
        onPressed: () {
          if (_isMounted) AppRoutes.goToMain(context);
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
    );
  }
}
