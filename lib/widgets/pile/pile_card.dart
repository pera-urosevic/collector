import 'package:flutter/material.dart';
import 'package:hoard/models/field_model.dart';
import 'package:hoard/widgets/artifact.dart';
import 'package:provider/provider.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/services/data_service.dart';

String formatIndex(FieldType type, dynamic value) {
  switch (type) {
    case FieldType.date:
      return formatDate(value);
    case FieldType.datetime:
      return formatDatetime(value);
    default:
      return value.toString();
  }
}

class PileCard extends StatelessWidget {
  final int index;
  const PileCard(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.read<ArtifactProvider>();

    List<FieldModel> subtitleFields = providerPile.fieldsIndex.where((field) => field.id != 'id').toList();

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 6),
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, subtitleFields.isNotEmpty ? 4 : 0),
          child: Text(
            providerPile.artifacts[index]['id'],
            style: const TextStyle(fontSize: 18),
          ),
        ),
        subtitle: subtitleFields.isNotEmpty
            ? Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(1),
                },
                children: subtitleFields
                    .map(
                      (field) => TableRow(
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
                                // TODO! date format
                                formatIndex(field.type, providerPile.artifacts[index][field.id]),
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              )
            : null,
        onTap: () {
          providerArtifact.load(providerPile, providerPile.artifacts[index]);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Artifact()));
        },
      ),
    );
  }
}
