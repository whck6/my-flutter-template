import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gitpod_flutter_quickstart/main.dart';

void main() {
  testWidgets('render MyApp', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    expect(find.text('Todo List'), findsOneWidget);
  });

  testWidgets('Add a todo', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    const key = Key('content');
    await tester.enterText(find.byKey(key), 'hi');
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();
    expect(find.text('hi'), findsOneWidget);
  });

  testWidgets('Remove a todo', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    const key = Key('content');
    await tester.enterText(find.byKey(key), 'hi');
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();
    expect(find.text('hi'), findsOneWidget);
    await tester.drag(find.byType(Dismissible), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('hi'), findsNothing);
  });
}
