import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collector/config.dart';
import 'package:collector/widgets/item/item_wide.dart';
import 'package:collector/widgets/item/item_tall.dart';

class Item extends StatelessWidget {
  const Item({super.key});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.of(context).pop();
        },
      },
      child: Focus(
        autofocus: true,
        child: config.get('mode') == 'tall' ? const ItemTall() : const ItemWide(),
      ),
    );
  }
}
