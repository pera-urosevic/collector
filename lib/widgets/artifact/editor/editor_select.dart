import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:provider/provider.dart';

class EditorSelect extends StatefulWidget {
  final String fieldId;
  final String value;
  final List<String>? lookup;
  const EditorSelect({super.key, required this.fieldId, required this.value, required this.lookup});

  @override
  State<EditorSelect> createState() => _EditorSelectState();
}

class _EditorSelectState extends State<EditorSelect> {
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

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: (value) => providerArtifact.setValue(widget.fieldId, value),
          ),
        ),
        PopupMenuButton<String>(
          initialValue: widget.value,
          icon: const Icon(Icons.arrow_drop_down),
          padding: const EdgeInsets.all(0),
          onSelected: (String newValue) {
            _controller.text = newValue;
            providerArtifact.setValue(widget.fieldId, newValue);
          },
          itemBuilder: (BuildContext context) {
            if (widget.lookup == null) return const [];
            return widget.lookup!
                .map(
                  (l) => PopupMenuItem<String>(
                    value: l,
                    child: Text(l),
                  ),
                )
                .toList();
          },
        )
      ],
    );
  }
}
