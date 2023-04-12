import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hoard/app.dart';
import 'package:hoard/config.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/providers/hoard_provider.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await dotenv.load();
  await cacheInit();

  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1024, 1104),
      title: 'Hoard',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setAlignment(kDebugMode ? Alignment.topRight : Alignment.center);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HoardProvider()),
        ChangeNotifierProvider(create: (_) => PileProvider()),
        ChangeNotifierProvider(create: (_) => ArtifactProvider()),
      ],
      child: const App(),
    ),
  );
}
