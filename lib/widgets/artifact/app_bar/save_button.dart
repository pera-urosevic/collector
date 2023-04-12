import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:hoard/services/ui.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({super.key});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    if (!providerArtifact.isValid) {
      return IconButton(
        icon: Icon(
          Icons.save,
          color: Theme.of(context).disabledColor,
        ),
        onPressed: null,
      );
    }

    return IconButton(
      icon: providerArtifact.isOverwriting ? const Icon(Icons.warning_amber) : const Icon(Icons.save),
      onPressed: () async {
        await providerPile.saveArtifact(providerArtifact.oldId, providerArtifact.get());
        if (!mounted) return;
        displayMessage(context, 'Saved "${providerArtifact.id}"');
        Navigator.of(context).pop();
      },
    );
  }
}
