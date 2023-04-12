import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/widgets/artifact.dart';
import 'package:hoard/widgets/hoard.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:hoard/theme.dart';
import 'package:hoard/widgets/pile.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Widget home = const Hoard();

  initDebug() async {
    String initialPage = 'Test';
    PileProvider providerPile = context.read<PileProvider>();
    await providerPile.loadPile(initialPage);
    setState(() => home = const Pile());

    if (!mounted) return;
    ArtifactProvider providerArtifact = context.read<ArtifactProvider>();
    providerArtifact.load(providerPile, providerPile.artifacts[1]);
    setState(() => home = const Artifact());
    return;
    // ignore: dead_code
  }

  @override
  initState() {
    if (kDebugMode) initDebug();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoard',
      theme: themeData,
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
