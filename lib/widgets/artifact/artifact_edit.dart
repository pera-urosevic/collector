import 'package:flutter/material.dart';
import 'package:hoard/models/field_model.dart';
import 'package:hoard/widgets/artifact/editor/editor_id.dart';
import 'package:hoard/widgets/artifact/editor/editor_boolean.dart';
import 'package:hoard/widgets/artifact/editor/editor_date.dart';
import 'package:hoard/widgets/artifact/editor/editor_datetime.dart';
import 'package:hoard/widgets/artifact/editor/editor_string.dart';
import 'package:hoard/widgets/artifact/editor/editor_text.dart';
import 'package:hoard/widgets/artifact/editor/editor_markdown.dart';
import 'package:hoard/widgets/artifact/editor/editor_list.dart';
import 'package:hoard/widgets/artifact/editor/editor_select.dart';
import 'package:hoard/widgets/artifact/editor/editor_tags.dart';
import 'package:hoard/widgets/artifact/editor/editor_image.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:hoard/services/data_service.dart';
import 'package:provider/provider.dart';

Widget fieldEditor(dynamic value, FieldModel field, Map<String, List<String>> lookups, String pileId) {
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
      return EditorImage(fieldId: field.id, value: value, pileId: pileId);
    default:
      return Container();
  }
}

class ArtifactEdit extends StatelessWidget {
  const ArtifactEdit({super.key});

  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: providerPile.fields.length,
        itemBuilder: (context, index) {
          FieldModel field = providerPile.fields[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleCase(field.id)),
                const SizedBox(height: 8),
                fieldEditor(providerArtifact.getValue(field.id), field, providerPile.lookups, providerPile.id),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
