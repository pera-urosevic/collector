import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:provider/provider.dart';

class EditorDate extends StatefulWidget {
  final String fieldId;
  final String value;
  const EditorDate({super.key, required this.fieldId, required this.value});

  @override
  State<EditorDate> createState() => _EditorDateState();
}

class _EditorDateState extends State<EditorDate> {
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
    ItemProvider providerItem = context.watch<ItemProvider>();

    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }

    return TextField(
      controller: _controller,
      onChanged: (value) => providerItem.setValue(widget.fieldId, value),
    );
  }
}
