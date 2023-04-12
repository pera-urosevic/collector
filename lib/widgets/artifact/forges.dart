import 'package:flutter/material.dart';
import 'package:hoard/models/artifact_model.dart';
import 'package:hoard/models/forge_model.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:hoard/widgets/artifact/forge_workers/forge_worker.dart';
import 'package:hoard/widgets/artifact/forge_workers/forge_worker_igdb.dart';
import 'package:hoard/widgets/artifact/forge_workers/forge_worker_rawg.dart';
import 'package:hoard/widgets/artifact/forge_workers/forge_worker_test.dart';
import 'package:provider/provider.dart';

ForgeWorker spawnForgeWorker(String name) {
  switch (name) {
    case 'IGDB':
      return ForgeWorkerIGDB();
    case 'RAWG':
      return ForgeWorkerRAWG();
    case 'Test':
      return ForgeWorkerTest();
    default:
      throw Exception('Forge not available');
  }
}

class Forges extends StatefulWidget {
  const Forges({Key? key}) : super(key: key);

  @override
  State<Forges> createState() => _ForgesState();
}

class _ForgesState extends State<Forges> {
  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    if (providerPile.forges.isEmpty) return Container();

    onForge(ForgeModel forgeModel) async {
      ForgeWorker forgeWorker = spawnForgeWorker(forgeModel.id);
      List<String> fields = forgeModel.fields;
      List results = await forgeWorker.search(providerArtifact.id);
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
                      ForgingModel forging = await forgeWorker.fetch(result['ref']);
                      ArtifactModel newArtifact = providerArtifact.get();
                      for (String field in fields) {
                        if (forging.containsKey(field) && forging[field] != null) {
                          newArtifact[field] = forging[field];
                        }
                      }
                      providerArtifact.set(newArtifact);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    if (providerPile.forges.length == 1) {
      return IconButton(
        icon: const Icon(Icons.cloud_download),
        onPressed: () => onForge(providerPile.forges.first),
      );
    }

    return PopupMenuButton(
      tooltip: 'Importers',
      icon: const Icon(Icons.cloud_download),
      itemBuilder: (context) => providerPile.forges
          .map((forge) => PopupMenuItem(
                value: forge,
                child: Text(forge.id),
              ))
          .toList(),
      onSelected: (forge) => onForge(forge),
    );
  }
}
