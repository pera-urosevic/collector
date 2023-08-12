import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:collector/services/ui_service.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({super.key});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.watch<ItemProvider>();

    if (!providerItem.isValid) {
      return IconButton(
        icon: Icon(
          Icons.save,
          color: Theme.of(context).disabledColor,
        ),
        onPressed: null,
      );
    }

    return IconButton(
      icon: providerItem.isOverwriting ? const Icon(Icons.warning_amber) : const Icon(Icons.save),
      onPressed: () async {
        await providerCollection.saveItem(providerItem.oldUid, providerItem.get());
        if (!mounted) return;
        displayMessage(context, 'Saved "${providerItem.uid}"');
        Navigator.of(context).pop();
      },
    );
  }
}
