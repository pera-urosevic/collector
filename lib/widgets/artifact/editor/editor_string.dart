import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:provider/provider.dart';

class EditorString extends StatefulWidget {
  final String fieldId;
  final String value;
  const EditorString({super.key, required this.fieldId, required this.value});

  @override
  State<EditorString> createState() => _EditorStringState();
}

class _EditorStringState extends State<EditorString> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }

    return TextField(
      controller: _controller,
      onChanged: (value) => providerArtifact.setValue(widget.fieldId, value),
    );
  }
}
