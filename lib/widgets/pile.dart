import 'package:flutter/material.dart';
import 'package:hoard/providers/hoard_provider.dart';
import 'package:hoard/services/data_service.dart';
import 'package:hoard/services/ui_service.dart';
import 'package:hoard/widgets/artifact.dart';
import 'package:hoard/widgets/pile/pile_bottom_bar.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/widgets/prompt.dart';
import 'package:provider/provider.dart';
import 'package:hoard/widgets/pile/pile_editor.dart';
import 'package:hoard/providers/pile_provider.dart';

class Pile extends StatefulWidget {
  const Pile({super.key});

  @override
  State<Pile> createState() => _PileState();
}

class _PileState extends State<Pile> {
  @override
  Widget build(BuildContext context) {
    HoardProvider providerHoard = context.watch<HoardProvider>();
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.read<ArtifactProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${providerPile.id} (${providerPile.artifacts.length})'),
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
                          String pileId = providerPile.id;
                          await providerHoard.removePile(pileId);
                          if (!mounted) return;
                          displayMessage(context, 'Removed "$pileId"');
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PileEditor())),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PileProvider>().loadPile(providerPile.id),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 56),
        child: ListView.builder(
          itemCount: providerPile.artifacts.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 6),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    providerPile.artifacts[index]['id'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                subtitle: Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: providerPile.fieldsIndex
                      .where((field) => field.id != 'id')
                      .map((field) => TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
                                  child: Text(
                                    titleCase(field.id),
                                    style: TextStyle(color: Colors.grey.shade500),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                  child: Text(
                                    providerPile.artifacts[index][field.id].toString(),
                                    style: TextStyle(color: Colors.grey.shade500),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                onTap: () {
                  providerArtifact.load(providerPile, providerPile.artifacts[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Artifact()));
                },
              ),
            );
          },
        ),
      ),
      bottomSheet: PileBottomBar(providerPile: providerPile),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          String newArtifactId = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Prompt(
                title: 'Create new artifact',
                hint: 'Artifact ID',
                valid: (value) => value.isNotEmpty,
              ),
            ),
          );
          providerArtifact.create(newArtifactId, providerPile);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Artifact(),
            ),
          );
        },
      ),
    );
  }
}