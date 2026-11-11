// Renders the web icons, favicon and social share image from Flutter widgets.
//
//   flutter test tool/generate_brand_assets_test.dart
//
// Writes into web/ (icons, favicon.png, og-image.png).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/theme/app_theme.dart';

Future<void> _loadFonts() async {
  for (final (family, files) in [
    ('SpaceGrotesk', ['SpaceGrotesk-700', 'SpaceGrotesk-500']),
    ('JetBrainsMono', ['JetBrainsMono-700', 'JetBrainsMono-500']),
    ('Inter', ['Inter-400', 'Inter-500']),
  ]) {
    final loader = FontLoader(family);
    for (final f in files) {
      final bytes = File('assets/fonts/$f.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }
}

Future<void> _render(
  WidgetTester tester,
  Widget widget,
  Size size,
  String path,
) async {
  final key = GlobalKey();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.fromSize(size: size, child: widget),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path).writeAsBytesSync(png!.buffer.asUint8List());
  });
}

/// "AK" monogram on the brand gradient. [safeZone] shrinks the glyph for
/// maskable icons, whose outer 20% may be cropped by the OS.
class _Mark extends StatelessWidget {
  const _Mark({required this.size, this.rounded = true, this.safeZone = 1});

  final double size;
  final bool rounded;
  final double safeZone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: rounded ? BorderRadius.circular(size * 0.22) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        'AK',
        style: TextStyle(
          fontFamily: AppText.monoFont,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.4 * safeZone,
          letterSpacing: -size * 0.01,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  const _ShareCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned(
            right: -90,
            top: -130,
            child: Container(
              width: 640,
              height: 640,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x558B5CF6), Color(0x008B5CF6)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 96, height: 96, child: _Mark(size: 96)),
                const Spacer(),
                Text(
                  'Amrut Khochikar',
                  style: AppText.display(76, letterSpacing: -2),
                ),
                const SizedBox(height: 14),
                ShaderMask(
                  shaderCallback: AppColors.primaryGradient.createShader,
                  child: Text(
                    'Flutter developer building AI-powered mobile apps',
                    style: AppText.display(
                      40,
                      weight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Flutter · Dart · Bloc · Riverpod · Firebase · On-device AI',
                  style: AppText.mono(24, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('generate brand assets', (tester) async {
    await tester.runAsync(_loadFonts);
    addTearDown(tester.view.reset);

    for (final s in [192, 512]) {
      await _render(
        tester,
        _Mark(size: s.toDouble()),
        Size.square(s.toDouble()),
        'web/icons/Icon-$s.png',
      );
      await _render(
        tester,
        _Mark(size: s.toDouble(), rounded: false, safeZone: 0.75),
        Size.square(s.toDouble()),
        'web/icons/Icon-maskable-$s.png',
      );
    }
    await _render(
      tester,
      const _Mark(size: 64),
      const Size.square(64),
      'web/favicon.png',
    );
    await _render(
      tester,
      const _ShareCard(),
      const Size(1200, 630),
      'web/og-image.png',
    );
  });
}
