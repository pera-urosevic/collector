import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:provider/provider.dart';

class EditorImage extends StatefulWidget {
  final String fieldId;
  final String value;
  final String collectionId;
  const EditorImage({super.key, required this.fieldId, required this.value, required this.collectionId});

  @override
  State<EditorImage> createState() => _EditorImageState();
}

class _EditorImageState extends State<EditorImage> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
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
      decoration: InputDecoration(
        hintText: widget.value,
      ),
      onChanged: (value) => providerItem.setValue(widget.fieldId, value),
    );
  }
}
