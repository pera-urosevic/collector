import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/widgets/item.dart';
import 'package:collector/widgets/collector.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:collector/theme.dart';
import 'package:collector/widgets/collection.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Widget home = const Collector();

  initDebug() async {
    return;
    // ignore: dead_code
    String initialPage = 'Test';
    CollectionProvider providerCollection = context.read<CollectionProvider>();
    await providerCollection.loadCollection(initialPage);
    setState(() => home = const Collection());

    if (!mounted) return;
    ItemProvider providerItem = context.read<ItemProvider>();
    providerItem.load(providerCollection, providerCollection.items[1]);
    setState(() => home = const Item());
  }

  @override
  initState() {
    if (kDebugMode) initDebug();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collector',
      theme: themeData,
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
