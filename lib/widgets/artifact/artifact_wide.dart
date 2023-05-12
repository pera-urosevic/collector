import 'package:flutter/material.dart';
import 'package:hoard/widgets/artifact/artifact_appbar.dart';
import 'package:hoard/widgets/artifact/artifact_edit.dart';
import 'package:hoard/widgets/artifact/artifact_view.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:provider/provider.dart';

class ArtifactWide extends StatelessWidget {
  const ArtifactWide({super.key});

  @override
  Widget build(BuildContext context) {
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    return Scaffold(
      appBar: ArtifactAppBar(
        artifactId: providerArtifact.id,
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ArtifactEdit(),
          ),
          Expanded(
            flex: 4,
            child: ArtifactView(),
          ),
        ],
      ),
    );
  }
}
