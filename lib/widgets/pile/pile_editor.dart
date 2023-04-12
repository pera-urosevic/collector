import 'package:flutter/material.dart';
import 'package:hoard/models/field_model.dart';
import 'package:hoard/models/filter_model.dart';
import 'package:hoard/models/forge_model.dart';
import 'package:hoard/services/data.dart';
import 'package:hoard/services/ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:hoard/services/json_service.dart';
import 'package:hoard/providers/pile_provider.dart';

const List<String> sections = [
  'fields',
  'filters',
  'forges',
  'template',
];

updateEditor(CodeController controller, String section, PileProvider providerPile) {
  switch (section) {
    case 'fields':
      controller.text = encode(providerPile.fields);
      controller.language = json;
      break;
    case 'filters':
      controller.text = encode(providerPile.filters);
      controller.language = json;
      break;
    case 'forges':
      controller.text = encode(providerPile.forges);
      controller.language = json;
      break;
    case 'template':
      controller.text = providerPile.template;
      controller.language = markdown;
      break;
    default:
      break;
  }
}

updatePile(PileProvider providerPile, String section, String text) {
  switch (section) {
    case 'fields':
      providerPile.fields = (decode(text) as List<dynamic>).map((j) => FieldModel.fromJson(j)).toList();
      break;
    case 'filters':
      providerPile.filters = (decode(text) as List<dynamic>).map((j) => FilterModel.fromJson(j)).toList();
      break;
    case 'forges':
      providerPile.forges = (decode(text) as List<dynamic>).map((j) => ForgeModel.fromJson(j)).toList();
      break;
    case 'template':
      providerPile.template = text;
      break;
    default:
      break;
  }
}

class PileEditor extends StatefulWidget {
  const PileEditor({super.key});

  @override
  State<PileEditor> createState() => _PileEditorState();
}

class _PileEditorState extends State<PileEditor> {
  String section = sections.first;
  late CodeController _codeController;

  @override
  void initState() {
    PileProvider providerPile = context.read<PileProvider>();
    _codeController = CodeController(
      modifiers: const [
        IndentModifier(),
        CloseBlockModifier(),
        TabModifier(),
      ],
    );
    updateEditor(_codeController, section, providerPile);
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editing: ${providerPile.id} / ${titleCase(section)}'),
        actions: [
          PopupMenuButton<String>(
            initialValue: providerPile.filter.id,
            icon: const Icon(Icons.arrow_drop_down),
            padding: const EdgeInsets.all(0),
            onSelected: (String newSection) {
              updateEditor(_codeController, newSection, providerPile);
              setState(() => section = newSection);
            },
            itemBuilder: (BuildContext context) => sections
                .map(
                  (section) => PopupMenuItem<String>(
                    value: section,
                    child: Text(titleCase(section)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: CodeTheme(
        data: CodeThemeData(styles: atomOneDarkTheme),
        child: CodeField(
          controller: _codeController,
          gutterStyle: GutterStyle(
            margin: 10,
            width: 60,
            showLineNumbers: true,
            background: themeData.inputDecorationTheme.fillColor,
            showErrors: true,
          ),
          minLines: null,
          maxLines: null,
          wrap: false,
          expands: true,
          background: themeData.inputDecorationTheme.fillColor,
          textStyle: const TextStyle(
            fontFamily: 'NotoSansMono Mono',
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          updatePile(providerPile, section, _codeController.text);
          await providerPile.savePile();
          if (!mounted) return;
          displayMessage(context, 'Saved ${titleCase(section)}');
        },
      ),
    );
  }
}
