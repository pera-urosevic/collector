import 'package:flutter/material.dart';
import 'package:collector/config.dart';
import 'package:collector/services/ui_service.dart';
import 'package:collector/widgets/collection.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:provider/provider.dart';
import 'package:collector/providers/collector_provider.dart';

class Collector extends StatefulWidget {
  const Collector({super.key});

  @override
  State<Collector> createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  late String mode;

  @override
  initState() {
    mode = config.get('mode');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectorProvider providerCollector = context.watch<CollectorProvider>();
    CollectionProvider providerCollection = context.watch<CollectionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collector'),
        actions: [
          IconButton(
            icon: Icon(
              mode == 'tall' ? Icons.horizontal_distribute : Icons.vertical_distribute,
            ),
            onPressed: () async {
              String newMode = mode == 'tall' ? 'wide' : 'tall';
              config.set('mode', newMode);
              setState(() => mode = newMode);
            },
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: Center(
        // list of collections
        child: ListView.builder(
          itemCount: providerCollector.size,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              providerCollector.collectionIds[index],
            ),
            onTap: () async {
              await providerCollection.loadCollection(providerCollector.collectionIds[index]);
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Collection(),
                ),
              );
            },
          ),
        ),
      ),
      // add a new collection
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          String? newCollectionId = await dialogString(
            context,
            'Create a new collection',
            'Title',
            (value) => RegExp('^[a-zA-Z0-9]+\$').hasMatch(value),
          );
          if (newCollectionId == null) return;
          await providerCollector.createCollection(newCollectionId);
        },
      ),
    );
  }
}
