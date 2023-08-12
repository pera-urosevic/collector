import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
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
    ItemProvider providerItem = context.watch<ItemProvider>();

    return Switch(
      value: widget.value,
      onChanged: (value) => providerItem.setValue(widget.fieldId, value),
    );
  }
}
