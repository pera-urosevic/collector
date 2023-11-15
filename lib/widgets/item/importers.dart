import 'package:flutter/material.dart';
import 'package:collector/models/item_model.dart';
import 'package:collector/models/importer_model.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:collector/widgets/item/importer_workers/importer_worker.dart';
import 'package:collector/widgets/item/importer_workers/importer_worker_igdb.dart';
import 'package:collector/widgets/item/importer_workers/importer_worker_rawg.dart';
import 'package:collector/widgets/item/importer_workers/importer_worker_test.dart';
import 'package:provider/provider.dart';

ImporterWorker spawnImporterWorker(String name) {
  switch (name) {
    case 'IGDB':
      return ImporterWorkerIGDB();
    case 'RAWG':
      return ImporterWorkerRAWG();
    case 'Test':
      return ImporterWorkerTest();
    default:
      throw Exception('Importer not available');
  }
}

class Importers extends StatefulWidget {
  const Importers({Key? key}) : super(key: key);

  @override
  State<Importers> createState() => _ImportersState();
}

class _ImportersState extends State<Importers> {
  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.watch<ItemProvider>();

    if (providerCollection.importers.isEmpty) return Container();

    onImporter(ImporterModel importerModel) async {
      ImporterWorker importerWorker = spawnImporterWorker(importerModel.id);
      List<String> fields = importerModel.fields;
      List results = await importerWorker.search(providerItem.id);
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Wrap(
              children: List.from(
                results.map(
                  (result) => ListTile(
                    title: Text(result['label']),
                    onTap: () async {
                      ImportingModel importing = await importerWorker.fetch(result['ref']);
                      ItemModel newItem = providerItem.get();
                      for (String field in fields) {
                        if (importing.containsKey(field) && importing[field] != null) {
                          newItem[field] = importing[field];
                        }
                      }
                      providerItem.set(newItem);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    if (providerCollection.importers.length == 1) {
      return IconButton(
        icon: const Icon(Icons.cloud_download),
        onPressed: () => onImporter(providerCollection.importers.first),
      );
    }

    return PopupMenuButton(
      tooltip: 'Importers',
      icon: const Icon(Icons.cloud_download),
      itemBuilder: (context) => List.from(
        providerCollection.importers.map(
          (importer) => PopupMenuItem(
            value: importer,
            child: Text(importer.id),
            onTap: () => onImporter(importer),
          ),
        ),
      ),
    );
  }
}
