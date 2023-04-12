import 'package:flutter/material.dart';

class Prompt extends StatefulWidget {
  final String title;
  final String hint;
  final bool Function(String value)? valid;

  const Prompt({super.key, required this.title, required this.hint, required this.valid});

  @override
  State<Prompt> createState() => _PromptState();
}

class _PromptState extends State<Prompt> {
  late TextEditingController _textController;
  bool inputValid = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        inputValid = widget.valid == null ? true : widget.valid!(_textController.text);
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  onSave(String value) {
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: _textController,
              onChanged: (value) => setState(() {
                inputValid = widget.valid == null ? true : widget.valid!(value);
              }),
              onSubmitted: onSave,
              decoration: InputDecoration(
                hintText: widget.hint,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      floatingActionButton: inputValid
          ? FloatingActionButton(
              onPressed: inputValid ? () => onSave(_textController.text) : null,
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
