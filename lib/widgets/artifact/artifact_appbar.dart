import 'package:flutter/material.dart';
import 'package:hoard/widgets/artifact/app_bar/random_button.dart';
import 'package:hoard/widgets/artifact/app_bar/remove_button.dart';
import 'package:hoard/widgets/artifact/app_bar/save_button.dart';
import 'package:hoard/widgets/artifact/app_bar/web_button.dart';
import 'package:hoard/widgets/artifact/forges.dart';

class ArtifactAppBar extends AppBar {
  final String artifactId;

  ArtifactAppBar({super.key, required this.artifactId})
      : super(
          title: Text(artifactId),
          actions: [
            const RemoveButton(),
            const SizedBox(width: 12),
            const RandomButton(),
            const WebButton(),
            const Forges(),
            const SaveButton(),
            const SizedBox(width: 8),
          ],
        );
}
