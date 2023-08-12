import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:provider/provider.dart';

class RandomButton extends StatefulWidget {
  const RandomButton({super.key});

  @override
  State<RandomButton> createState() => _RandomButtonState();
}

class _RandomButtonState extends State<RandomButton> {
  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.watch<ItemProvider>();

    return IconButton(
      icon: const Icon(Icons.casino),
      onPressed: () async {
        providerItem.load(providerCollection, providerCollection.randomItem());
      },
    );
  }
}
