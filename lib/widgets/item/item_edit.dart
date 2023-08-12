import 'package:flutter/material.dart';
import 'package:collector/models/field_model.dart';
import 'package:collector/widgets/item/editor/editor_id.dart';
import 'package:collector/widgets/item/editor/editor_boolean.dart';
import 'package:collector/widgets/item/editor/editor_date.dart';
import 'package:collector/widgets/item/editor/editor_datetime.dart';
import 'package:collector/widgets/item/editor/editor_string.dart';
import 'package:collector/widgets/item/editor/editor_text.dart';
import 'package:collector/widgets/item/editor/editor_markdown.dart';
import 'package:collector/widgets/item/editor/editor_list.dart';
import 'package:collector/widgets/item/editor/editor_select.dart';
import 'package:collector/widgets/item/editor/editor_tags.dart';
import 'package:collector/widgets/item/editor/editor_image.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:collector/services/data_service.dart';
import 'package:provider/provider.dart';

Widget fieldEditor(dynamic value, FieldModel field, Map<String, List<String>> lookups, String collectionId) {
  value ??= field.defaultValue;
  switch (field.type) {
    case FieldType.id:
      return EditorId(fieldId: field.id, value: value);
    case FieldType.boolean:
      return EditorBoolean(fieldId: field.id, value: value);
    case FieldType.date:
      return EditorDate(fieldId: field.id, value: value);
    case FieldType.datetime:
      return EditorDatetime(fieldId: field.id, value: value);
    case FieldType.string:
      return EditorString(fieldId: field.id, value: value);
    case FieldType.text:
      return EditorText(fieldId: field.id, value: value);
    case FieldType.markdown:
      return EditorMarkdown(fieldId: field.id, value: value);
    case FieldType.list:
      return EditorList(fieldId: field.id, value: value);
    case FieldType.select:
      return EditorSelect(fieldId: field.id, value: value, lookup: lookups[field.id]);
    case FieldType.tags:
      return EditorTags(fieldId: field.id, values: value, lookup: lookups[field.id]);
    case FieldType.image:
      return EditorImage(fieldId: field.id, value: value, collectionId: collectionId);
    default:
      return Container();
  }
}

class ItemEdit extends StatelessWidget {
  const ItemEdit({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.watch<ItemProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: providerCollection.fields.length,
        itemBuilder: (context, index) {
          FieldModel field = providerCollection.fields[index];
          if (field.type == FieldType.uid) return Container();
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleCase(field.id)),
                const SizedBox(height: 8),
                fieldEditor(providerItem.getValue(field.id), field, providerCollection.lookups, providerCollection.id),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
