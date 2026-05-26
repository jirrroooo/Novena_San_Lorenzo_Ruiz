import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novena_lorenzo/common/splash_screen.dart';

import 'package:novena_lorenzo/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MyApp shows SplashScreen as initial route',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(400, 800)),
          child: MyApp(),
        ),
      );

      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);

      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}
