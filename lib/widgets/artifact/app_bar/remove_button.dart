import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:hoard/services/ui.dart';
import 'package:provider/provider.dart';

class RemoveButton extends StatefulWidget {
  const RemoveButton({super.key});

  @override
  State<RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<RemoveButton> {
  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to remove?'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    await providerPile.removeArtifact(providerArtifact.get());
                    if (!mounted) return;
                    displayMessage(context, 'Removed "${providerArtifact.id}"');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
