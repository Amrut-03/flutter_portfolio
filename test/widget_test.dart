import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

const _headline = 'Building AI-Powered Mobile Apps with Flutter';

Future<void> pumpAt(
  WidgetTester tester,
  Size size, {
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  if (reduceMotion) {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  }
  await tester.pumpWidget(const PortfolioApp());
  // The particle background loops forever unless motion is reduced, so only
  // settle in reduced-motion mode.
  if (reduceMotion) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 300));
  }
}

ScrollableState _page(WidgetTester tester) =>
    tester.state<ScrollableState>(find.byType(Scrollable).first);

/// Jumps the page scrollable to [offset] without pointer events. Any
/// RenderFlex overflow throws during the pump.
Future<void> scrollTo(WidgetTester tester, double offset) async {
  final position = _page(tester).position;
  position.jumpTo(offset.clamp(0.0, position.maxScrollExtent));
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  testWidgets('renders hero content', (tester) async {
    await pumpAt(tester, const Size(1280, 900));
    expect(find.text(_headline), findsOneWidget);
    expect(find.text('Amrut Khochikar'), findsWidgets);
    expect(find.text('LATEST WORK'), findsOneWidget);
  });

  testWidgets('shows hamburger menu on mobile and expands it', (tester) async {
    await pumpAt(tester, const Size(420, 800));

    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(find.text('Achievements'), findsNothing);
    expect(find.text('Contact'), findsNothing);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
  });

  testWidgets('displays desktop nav links on wide screens', (tester) async {
    await pumpAt(tester, const Size(1280, 900));
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsNothing);
  });

  testWidgets('nav link scrolls to its section', (tester) async {
    await pumpAt(tester, const Size(1280, 900), reduceMotion: true);
    expect(_page(tester).position.pixels, 0);

    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    expect(_page(tester).position.pixels, greaterThan(0));
    expect(find.text('Featured Work').hitTestable(), findsOneWidget);
  });

  testWidgets('renders core focus panel and new content', (tester) async {
    await pumpAt(tester, const Size(1280, 900));
    expect(find.text('CORE FOCUS'), findsOneWidget);
    expect(find.text('On-device AI in Flutter'), findsOneWidget);
    expect(find.text('flutter_body_part_selector'), findsOneWidget);
    expect(
      find.textContaining('Promoted from Software Engineer Intern'),
      findsOneWidget,
    );
  });

  testWidgets('contact form validates before sending', (tester) async {
    await pumpAt(tester, const Size(1280, 900), reduceMotion: true);
    final send = find.text('Send Message');
    await tester.ensureVisible(send);
    await tester.pumpAndSettle();

    await tester.tap(send);
    await tester.pumpAndSettle();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter an email'), findsOneWidget);
    expect(find.text('Please enter a message'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'not-an-email',
    );
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'jane@example.com',
    );
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email'), findsNothing);
  });

  for (final size in const [
    Size(360, 700), // small mobile
    Size(420, 800), // mobile
    Size(768, 1024), // tablet portrait
    Size(1024, 768), // tablet landscape
    Size(1280, 900), // desktop
    Size(1920, 1080), // large desktop
  ]) {
    testWidgets(
      'no layout overflow when scrolling at ${size.width}x${size.height}',
      (tester) async {
        await pumpAt(tester, size);
        final max = _page(tester).position.maxScrollExtent;
        for (var i = 0; i <= 12; i++) {
          await scrollTo(tester, max / 12 * i);
        }
        await scrollTo(tester, 0);
      },
    );
  }
}
