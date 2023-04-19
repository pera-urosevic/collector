import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/config.dart';
import 'package:hoard/widgets/artifact/artifact_wide.dart';
import 'package:hoard/widgets/artifact/artifact_tall.dart';

class Artifact extends StatelessWidget {
  const Artifact({super.key});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.of(context).pop();
        },
      },
      child: Focus(
        autofocus: true,
        child: config.get('mode') == 'tall' ? const ArtifactTall() : const ArtifactWide(),
      ),
    );
  }
}
