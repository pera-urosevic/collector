import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:collector/app.dart';
import 'package:collector/config.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

checkPermission() async {
  if (await Permission.manageExternalStorage.isDenied) {
    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      openAppSettings();
      return;
    }
    await Permission.manageExternalStorage.request();
  }
}

void main() async {
  await dotenv.load();
  await cacheInit();

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await checkPermission();
  }
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1024, 1104),
      title: 'Collector',
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
        ChangeNotifierProvider(create: (_) => CollectorProvider()),
        ChangeNotifierProvider(create: (_) => CollectionProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: const App(),
    ),
  );
}
