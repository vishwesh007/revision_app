// A tiny script to generate simple PNG icons for launcher (squared and foreground)
import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  final outDir = Directory('assets/icon');
  if (!await outDir.exists()) await outDir.create(recursive: true);

  // Base canvas
  const size = 1024;
  final bg = img.Image(width: size, height: size);
  // Indigo 600 background
  final indigo = img.ColorRgb8(0x4F, 0x46, 0xE5);
  img.fill(bg, color: indigo);

  // Foreground canvas (transparent) for adaptive icon foreground
  final fg = img.Image(width: size, height: size);

  // Draw two white blocks to hint "RB" lettermark (designer-friendly abstract)
  final white = img.ColorRgb8(0xFF, 0xFF, 0xFF);

  // Left block (R)
  img.fillRect(fg, x1: 220, y1: 312, x2: 460, y2: 712, color: white);
  // Right block (B)
  img.fillRect(fg, x1: 564, y1: 312, x2: 804, y2: 712, color: white);
  // A thin center bar to balance
  img.fillRect(fg, x1: 496, y1: 312, x2: 528, y2: 712, color: white);

  // Composite foreground onto background for full icon
  final composed = img.compositeImage(bg.clone(), fg, dstX: 0, dstY: 0);

  // Save base icon (png)
  await File('assets/icon/icon.png').writeAsBytes(img.encodePng(composed));

  // Save foreground icon (for adaptive)
  await File('assets/icon/icon_foreground.png').writeAsBytes(img.encodePng(fg));

  // Optional 512 reference
  final small = img.copyResize(composed, width: 512, height: 512);
  await File('assets/icon/icon_512.png').writeAsBytes(img.encodePng(small));

  stdout.writeln('Generated icons in assets/icon');
}

// No rounded corners utility needed for the simplified icon
