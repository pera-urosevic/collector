import 'package:flutter/material.dart';
import 'package:hoard/config.dart';
import 'package:hoard/widgets/artifact/artifact_wide.dart';
import 'package:hoard/widgets/artifact/artifact_tall.dart';

class Artifact extends StatelessWidget {
  const Artifact({super.key});

  @override
  Widget build(BuildContext context) {
    return config.get('mode') == 'tall' ? const ArtifactTall() : const ArtifactWide();
  }
}
