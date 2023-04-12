import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:provider/provider.dart';

class RandomButton extends StatefulWidget {
  const RandomButton({super.key});

  @override
  State<RandomButton> createState() => _RandomButtonState();
}

class _RandomButtonState extends State<RandomButton> {
  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    return IconButton(
      icon: const Icon(Icons.casino),
      onPressed: () async {
        providerArtifact.load(providerPile, providerPile.randomArtifact());
      },
    );
  }
}
