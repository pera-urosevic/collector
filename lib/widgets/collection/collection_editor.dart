import 'package:flutter/material.dart';
import 'package:collector/models/field_model.dart';
import 'package:collector/models/filter_model.dart';
import 'package:collector/models/importer_model.dart';
import 'package:collector/services/data_service.dart';
import 'package:collector/services/ui_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:collector/services/json_service.dart';
import 'package:collector/providers/collection_provider.dart';

const List<String> sections = [
  'template',
  'filters',
  'fields',
  'importers',
];

updateEditor(CodeController controller, String section, CollectionProvider providerCollection) {
  switch (section) {
    case 'fields':
      controller.text = encode(providerCollection.fields);
      controller.language = json;
      break;
    case 'filters':
      controller.text = encode(providerCollection.filters);
      controller.language = json;
      break;
    case 'importers':
      controller.text = encode(providerCollection.importers);
      controller.language = json;
      break;
    case 'template':
      controller.text = providerCollection.template;
      controller.language = markdown;
      break;
    default:
      break;
  }
}

updateCollection(CollectionProvider providerCollection, String section, String text) {
  switch (section) {
    case 'fields':
      providerCollection.fields = (decode(text) as List<dynamic>).map((j) => FieldModel.fromJson(j)).toList();
      break;
    case 'filters':
      providerCollection.filters = (decode(text) as List<dynamic>).map((j) => FilterModel.fromJson(j)).toList();
      break;
    case 'importers':
      providerCollection.importers = (decode(text) as List<dynamic>).map((j) => ImporterModel.fromJson(j)).toList();
      break;
    case 'template':
      providerCollection.template = text;
      break;
    default:
      break;
  }
}

class CollectionEditor extends StatefulWidget {
  const CollectionEditor({super.key});

  @override
  State<CollectionEditor> createState() => _CollectionEditorState();
}

class _CollectionEditorState extends State<CollectionEditor> {
  String _section = sections.first;
  late CodeController _codeController;

  @override
  void initState() {
    CollectionProvider providerCollection = context.read<CollectionProvider>();
    _codeController = CodeController(
      modifiers: const [
        IndentModifier(),
        CloseBlockModifier(),
        TabModifier(),
      ],
    );
    updateEditor(_codeController, _section, providerCollection);
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(titleCase(_section)),
              PopupMenuButton<String>(
                initialValue: providerCollection.filter.id,
                icon: const Icon(Icons.arrow_drop_down),
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context) => List.from(
                  sections.map(
                    (section) => PopupMenuItem<String>(
                      value: section,
                      child: Text(titleCase(section)),
                      onTap: () {
                        updateEditor(_codeController, section, providerCollection);
                        setState(() => _section = section);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: CodeTheme(
          data: CodeThemeData(styles: atomOneDarkTheme),
          child: CodeField(
            controller: _codeController,
            gutterStyle: const GutterStyle(
              showLineNumbers: false,
              showErrors: false,
              showFoldingHandles: true,
            ),
            minLines: null,
            maxLines: null,
            wrap: false,
            expands: false,
            background: themeData.inputDecorationTheme.fillColor,
            textStyle: const TextStyle(
              fontFamily: 'NotoSansMono',
              fontSize: 14,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          updateCollection(providerCollection, _section, _codeController.text);
          await providerCollection.saveCollection();
          if (!mounted) return;
          displayMessage(context, 'Saved ${titleCase(_section)}');
        },
      ),
    );
  }
}
