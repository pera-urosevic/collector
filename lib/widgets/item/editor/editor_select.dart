import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
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
    ItemProvider providerItem = context.watch<ItemProvider>();

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
            onChanged: (value) => providerItem.setValue(widget.fieldId, value),
          ),
        ),
        PopupMenuButton<String>(
          initialValue: widget.value,
          icon: const Icon(Icons.arrow_drop_down),
          padding: const EdgeInsets.all(0),
          itemBuilder: (BuildContext context) {
            if (widget.lookup == null) return const [];
            return List.from(
              widget.lookup!.map(
                (l) => PopupMenuItem<String>(
                  value: l,
                  child: Text(l),
                  onTap: () {
                    _controller.text = l;
                    providerItem.setValue(widget.fieldId, l);
                  },
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
