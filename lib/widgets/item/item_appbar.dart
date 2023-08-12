import 'package:flutter/material.dart';
import 'package:collector/widgets/item/app_bar/random_button.dart';
import 'package:collector/widgets/item/app_bar/remove_button.dart';
import 'package:collector/widgets/item/app_bar/save_button.dart';
import 'package:collector/widgets/item/app_bar/web_button.dart';
import 'package:collector/widgets/item/importers.dart';

class ItemAppBar extends AppBar {
  final String itemId;

  ItemAppBar({super.key, required this.itemId})
      : super(
          title: Text(itemId),
          actions: [
            const RemoveButton(),
            const SizedBox(width: 12),
            const RandomButton(),
            const WebButton(),
            const Importers(),
            const SaveButton(),
            const SizedBox(width: 8),
          ],
        );
}
