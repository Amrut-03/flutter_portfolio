import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/main.dart';

Future<void> pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const PortfolioApp());
  // Particle background loops forever, so avoid pumpAndSettle.
  await tester.pump(const Duration(milliseconds: 300));
}

/// Jumps the page-level scrollable to [offset] and pumps a frame, avoiding
/// pointer events so the continuous particle animation can't destabilise the
/// drag hit-testing. Any RenderFlex-overflow throws during the pump.
Future<void> scrollTo(WidgetTester tester, double offset) async {
  final scrollable = tester.state<ScrollableState>(
    find.byType(Scrollable).first,
  );
  scrollable.position.jumpTo(offset.clamp(
    0.0,
    scrollable.position.maxScrollExtent,
  ));
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  testWidgets('renders hero content', (WidgetTester tester) async {
    await pumpAt(tester, const Size(1280, 900));
    expect(find.text('Building Scalable Cross-Platform Apps with Flutter'),
        findsOneWidget);
    expect(find.text('Amrut Khochikar'), findsWidgets);
  });

  testWidgets('shows hamburger menu on mobile and expands it',
      (WidgetTester tester) async {
    await pumpAt(tester, const Size(420, 800));

    // Nav links hidden behind hamburger (below 1180px).
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    // Only the section headings are present before opening the menu.
    expect(find.text('Achievements'), findsNothing);
    expect(find.text('Contact'), findsNothing);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pump(const Duration(milliseconds: 400));

    // Mobile menu links now present ("Achievements" = menu link).
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
  });

  testWidgets('displays desktop nav links on wide screens',
      (WidgetTester tester) async {
    await pumpAt(tester, const Size(1280, 900));
    // Desktop nav link present ("Achievements" only in nav, heading uses
    // uppercase label + "Achievements & Recognition" title).
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsNothing);
  });

  testWidgets('renders skill bars', (WidgetTester tester) async {
    await pumpAt(tester, const Size(1280, 900));
    expect(find.text('TOP SKILLS'), findsOneWidget);
    expect(find.text('GetX State Management'), findsOneWidget);
  });

  for (final size in const [
    Size(360, 700), // small mobile
    Size(420, 800), // mobile
    Size(768, 1024), // tablet portrait
    Size(1024, 768), // tablet landscape
    Size(1280, 900), // desktop
  ]) {
    testWidgets('no layout overflow when scrolling at ${size.width}x${size.height}',
        (WidgetTester tester) async {
      await pumpAt(tester, size);
      // Jump the page scrollable through the full content; any
      // RenderFlex-overflow throws during these frames. Driving the scroll
      // position directly (no pointer events) avoids destabilising the
      // continuously-animating particle background mid-gesture.
      const total = 3000.0;
      for (var i = 0; i <= 10; i++) {
        await scrollTo(tester, (total / 10) * i);
      }
      await scrollTo(tester, 0);
    });
  }
}
