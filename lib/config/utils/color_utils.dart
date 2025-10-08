import 'dart:typed_data' as ui;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorUtils {
  /// Extracts the most frequent (prominent) color from an image asset.
  static Future<Color> getProminentColorFromAsset(String assetPath) async {
    // Load image bytes
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    // Decode image
    final ui.Image image = await decodeImageFromList(bytes);

    // Convert image to byte data (RGBA)
    final ui.ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (byteData == null) return Colors.grey;

    final Uint8List pixels = byteData.buffer.asUint8List();

    // Count color frequency
    final Map<int, int> colorCount = {};
    for (int i = 0; i < pixels.length; i += 4) {
      int r = pixels[i];
      int g = pixels[i + 1];
      int b = pixels[i + 2];
      int a = pixels[i + 3];

      if (a < 128) continue; // skip transparent pixels

      int colorValue = (r << 16) | (g << 8) | b;
      colorCount[colorValue] = (colorCount[colorValue] ?? 0) + 1;
    }

    // Find most frequent color
    int prominentColorValue = colorCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return Color(0xFF000000 | prominentColorValue);
  }
}
