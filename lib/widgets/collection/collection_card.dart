import 'package:flutter/material.dart';
import 'package:collector/models/field_model.dart';
import 'package:collector/widgets/item.dart';
import 'package:provider/provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/services/data_service.dart';

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

class CollectionCard extends StatelessWidget {
  final int index;
  const CollectionCard(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.read<ItemProvider>();

    List<FieldModel> subtitleFields = providerCollection.fieldsIndex.where((field) => field.id != 'id').toList();

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 6),
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, subtitleFields.isNotEmpty ? 4 : 0),
          child: Text(
            providerCollection.items[index]['id'],
            style: const TextStyle(fontSize: 18),
          ),
        ),
        subtitle: subtitleFields.isNotEmpty
            ? Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(1),
                },
                children: List.from(
                  subtitleFields.map(
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
                              formatIndex(field.type, providerCollection.items[index][field.id]),
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
        onTap: () {
          providerItem.load(providerCollection, providerCollection.items[index]);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Item()));
        },
      ),
    );
  }
}
