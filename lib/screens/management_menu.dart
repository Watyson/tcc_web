import 'package:flutter/material.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_elevated_button.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/user.dart';

import 'package:mobile/utils/api_service.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';

import 'package:mobile/components/widget_app_bar.dart';
import 'package:mobile/components/widget_icon_food.dart';

import 'package:mobile/models/product.dart';

import 'package:mobile/routes.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
      body: FutureBuilder<List<Product>>(
        future: ApiService.getProducts(0, 100),
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
    );
  }

  Widget _buildProductListView(List<Product> productList) {
    return Center(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: () {
              if (_isMounted) {
                AppRoutes.goToUpdateProduct(context, arguments: productList[index]);
              }
            },
            child: WidgetIconFood(
              product: productList.elementAt(index),
              onPressedDeleteItem: () async {
                await ApiService.productDelete(productList[index]);
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return WidgetAppBar(
      title: AppLocalizations.of(context)!.menu,
      icon1: IconButton(
        onPressed: () {
          if (_isMounted) AppRoutes.goToMain(context);
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      icon2: IconButton(
        onPressed: () {
          if (_isMounted) AppRoutes.goToRegisterProduct(context);
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
