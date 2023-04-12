import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:provider/provider.dart';

class EditorList extends StatefulWidget {
  final String fieldId;
  final List<dynamic> value;
  const EditorList({super.key, required this.fieldId, required this.value});

  @override
  State<EditorList> createState() => _EditorListState();
}

class _EditorListState extends State<EditorList> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value.join('\n'));
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

    String valueText = widget.value.join('\n');
    if (valueText != _controller.text) {
      _controller.value = TextEditingValue(
        text: valueText,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }

    return TextField(
      minLines: 6,
      maxLines: 6,
      controller: _controller,
      onChanged: (value) => providerArtifact.setValue(widget.fieldId, value.split('\n')),
    );
  }
}
