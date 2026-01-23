import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novena_lorenzo/common/splash_screen.dart';
import 'package:novena_lorenzo/homepage.dart';

import 'package:novena_lorenzo/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MyApp shows SplashScreen as initial route',
      (WidgetTester tester) async {
    // Run async code safely
    await tester.runAsync(() async {
      // Wrap in MaterialApp with fixed size to avoid overflow errors
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(400, 800)),
          child: MyApp(),
        ),
      );

      // Pump once to build widgets
      await tester.pump();

      // Check that MaterialApp exists
      expect(find.byType(MaterialApp), findsOneWidget);

      // Check that SplashScreen is shown
      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}
