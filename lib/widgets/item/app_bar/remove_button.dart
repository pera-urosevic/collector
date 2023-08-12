import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:collector/services/ui_service.dart';
import 'package:provider/provider.dart';

class RemoveButton extends StatefulWidget {
  const RemoveButton({super.key});

  @override
  State<RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<RemoveButton> {
  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.watch<ItemProvider>();

    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to remove?'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    await providerCollection.removeItem(providerItem.get());
                    if (!mounted) return;
                    displayMessage(context, 'Removed "${providerItem.uid}"');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
