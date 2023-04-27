import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/services/ui_service.dart';
import 'package:provider/provider.dart';

class EditorTags extends StatefulWidget {
  final String fieldId;
  final List<dynamic> values;
  final List<String>? lookup;
  const EditorTags({super.key, required this.fieldId, required this.values, required this.lookup});

  @override
  State<EditorTags> createState() => _EditorTagsState();
}

class _EditorTagsState extends State<EditorTags> {
  @override
  Widget build(BuildContext context) {
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    List<String> lookup = [];
    if (widget.lookup != null) {
      lookup = widget.lookup!.where((l) => !widget.values.contains(l)).toList();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 4,
            runSpacing: 4,
            children: List.from(
              widget.values.map(
                (value) => Chip(
                  label: Text(value),
                  onDeleted: () {
                    List<dynamic> newValues = widget.values.where((v) => v != value).toList();
                    providerArtifact.setValue(widget.fieldId, newValues);
                  },
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            String? newValue = await dialogString(context, 'Add tag', 'Tag value', (v) => v.isNotEmpty);
            if (newValue == null) return;
            List<dynamic> newValues = List.from(widget.values)..add(newValue);
            providerArtifact.setValue(widget.fieldId, newValues);
          },
        ),
        lookup.isEmpty
            ? Container()
            : PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context) {
                  return List.from(
                    lookup.map(
                      (l) => PopupMenuItem<String>(
                        value: l,
                        child: Text(l),
                        onTap: () {
                          List<dynamic> newValues = List.from(widget.values)..add(l);
                          providerArtifact.setValue(widget.fieldId, newValues);
                        },
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
