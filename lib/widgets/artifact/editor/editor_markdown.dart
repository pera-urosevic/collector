import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:provider/provider.dart';

class EditorMarkdown extends StatefulWidget {
  final String fieldId;
  final String value;
  const EditorMarkdown({super.key, required this.fieldId, required this.value});

  @override
  State<EditorMarkdown> createState() => _EditorMarkdownState();
}

class _EditorMarkdownState extends State<EditorMarkdown> {
  late CodeController _codeController;

  @override
  void initState() {
    _codeController = CodeController(
      text: widget.value,
      language: markdown,
      modifiers: const [
        IndentModifier(),
        CloseBlockModifier(),
        TabModifier(),
      ],
    );
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    ThemeData themeData = Theme.of(context);

    if (widget.value != _codeController.text) {
      _codeController.value = TextEditingValue(
        text: widget.value,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 436,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: CodeTheme(
            data: CodeThemeData(styles: atomOneDarkTheme),
            child: CodeField(
              cursorColor: themeData.textSelectionTheme.cursorColor,
              decoration: BoxDecoration(
                color: themeData.inputDecorationTheme.fillColor,
              ),
              padding: const EdgeInsets.all(0),
              controller: _codeController,
              onChanged: (newValue) => providerArtifact.setValue(widget.fieldId, newValue),
              gutterStyle: const GutterStyle(
                margin: 0,
                width: 0,
                showLineNumbers: false,
                showErrors: false,
                showFoldingHandles: false,
              ),
              background: themeData.inputDecorationTheme.fillColor,
              minLines: 20,
              textStyle: const TextStyle(
                fontFamily: 'NotoSansMono Mono',
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
