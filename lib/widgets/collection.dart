import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/services/ui_service.dart';
import 'package:collector/widgets/item.dart';
import 'package:collector/widgets/collection/collection_bottom_bar.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/widgets/collection/collection_card.dart';
import 'package:provider/provider.dart';
import 'package:collector/widgets/collection/collection_editor.dart';
import 'package:collector/providers/collection_provider.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    CollectorProvider providerCollector = context.watch<CollectorProvider>();
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.read<ItemProvider>();

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.of(context).pop();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${providerCollection.id} (${providerCollection.items.length})'),
            actions: [
              IconButton(
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
                              String collectionId = providerCollection.id;
                              await providerCollector.removeCollection(collectionId);
                              if (!mounted) return;
                              displayMessage(context, 'Removed "$collectionId"');
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
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CollectionEditor())),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<CollectionProvider>().loadCollection(providerCollection.id),
              ),
              const SizedBox(width: 8)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 56),
            child: ListView.builder(
              itemCount: providerCollection.items.length,
              itemBuilder: (context, index) {
                return CollectionCard(index);
              },
            ),
          ),
          bottomSheet: CollectionBottomBar(providerCollection: providerCollection),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              String? newItemId = await dialogString(
                context,
                'Create a new item',
                'Title',
                (value) => value.isNotEmpty,
              );
              if (newItemId == null) return;
              providerItem.create(newItemId, providerCollection);
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Item(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
