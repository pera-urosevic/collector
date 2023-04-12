import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:provider/provider.dart';

class EditorBoolean extends StatefulWidget {
  final String fieldId;
  final bool value;
  const EditorBoolean({super.key, required this.fieldId, required this.value});

  @override
  State<EditorBoolean> createState() => _EditorBooleanState();
}

class _EditorBooleanState extends State<EditorBoolean> {
  @override
  Widget build(BuildContext context) {
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    return Switch(
      value: widget.value,
      onChanged: (value) => providerArtifact.setValue(widget.fieldId, value),
    );
  }
}
