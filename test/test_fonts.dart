import 'dart:io';

import 'package:flutter/services.dart';

/// Testlerde gerçek fontları yükler; yoksa test fontu harfleri kare çizer ve
/// yerleşim (taşma) gerçeği yansıtmaz.
Future<void> loadAppFonts() async {
  Future<void> load(String family, List<String> paths) async {
    final loader = FontLoader(family);
    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) {
        loader.addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
      }
    }
    await loader.load();
  }

  await load('Nunito', ['assets/fonts/Nunito.ttf']);

  // Material ikonları Flutter SDK'nın içinden.
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    await load('MaterialIcons', [
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ]);
  }
}
