import 'package:flutter/material.dart';
import 'package:collector/widgets/item/item_appbar.dart';
import 'package:collector/widgets/item/item_edit.dart';
import 'package:collector/widgets/item/item_view.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:provider/provider.dart';

class ItemWide extends StatelessWidget {
  const ItemWide({super.key});

  @override
  Widget build(BuildContext context) {
    ItemProvider providerItem = context.watch<ItemProvider>();

    return Scaffold(
      appBar: ItemAppBar(
        itemId: providerItem.id,
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: ItemEdit(),
          ),
          Expanded(
            flex: 1,
            child: ItemView(),
          ),
        ],
      ),
    );
  }
}
