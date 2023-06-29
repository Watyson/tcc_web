import 'package:flutter/material.dart';
import 'package:mobile/components/widget_column.dart';
import 'package:mobile/components/widget_container.dart';
import 'package:mobile/components/widget_imagem.dart';
import 'package:mobile/components/widget_row.dart';
import 'package:mobile/components/widget_text.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/utils/app_localizations/app_localizations.dart';
import 'package:mobile/utils/widgets.dart';

class WidgetIconFood extends StatelessWidget {
  final Product product;
  final double imageWidth;
  final Function onPressedDeleteItem;

  const WidgetIconFood({
    Key? key,
    required this.product,
    this.imageWidth = 150,
    required this.onPressedDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = !product.available ? const Color.fromARGB(255, 255, 0, 0) : const Color.fromARGB(255, 0, 128, 255);

    return WidgetRow(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: WidgetImage(
            url: product.image,
            width: imageWidth,
            height: imageWidth / 1.5,
          ),
        ),
        Expanded(
          child: WidgetColumn(
            children: [
              WidgetText(
                text: product.name,
                style: TextStyle(fontSize: 18, color: color),
              ),
              WidgetText(
                text: "R\$ ${product.price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 15, color: color),
              ),
            ],
          ),
        ),
        WidgetContainer(
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
                        onPressed: () {
                          onPressedDeleteItem();
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
        const SizedBox(width: 50),
      ],
    );
  }
}
