import 'package:authentication_demo/src/features/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget runLoginScreen() {
  return const MaterialApp(home: LoginScreen());
}

void main() {
  testWidgets('should login successfully', (WidgetTester tester) async {
    await tester.pumpWidget(runLoginScreen());

    // Find the title
    expect(find.text("Login"), findsOneWidget);

    // Find the TextFormField for email
    final emailField = find.byKey(const Key('emailField'));
    expect(emailField, findsOneWidget);

    // Enter a valid email address
    await tester.enterText(emailField, 'test@example.com');
    await tester.pump();

    // Find the TextFormField for password
    final passwordField = find.byKey(const Key('passField'));
    expect(passwordField, findsOneWidget);

    // Enter a valid password
    await tester.enterText(passwordField, 'password123');
    await tester.pump();

    // Find the Submit button
    final submitButton = find.text('Submit');
    expect(submitButton, findsOneWidget);

    // Tap the Submit button
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Check if the form was submitted successfully
    expect(find.text('Form submitted'), findsOneWidget);
  });

  testWidgets('should show required fields', (WidgetTester tester) async {
    await tester.pumpWidget(runLoginScreen());

    // Find the Submit button
    final submitButton = find.text('Submit');

    // Tap the Submit button
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Check if validation error messages are displayed
    expect(find.text('Field is required'), findsNWidgets(2));
  });

  testWidgets('should show invalid email', (WidgetTester tester) async {
    await tester.pumpWidget(runLoginScreen());

    // Find the TextFormField for email
    final emailField = find.byKey(const Key('emailField'));

    // Enter a valid email address
    await tester.enterText(emailField, 'test');
    await tester.pump();

    // Find the Submit button
    final submitButton = find.text('Submit');

    // Tap the Submit button
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Check if validation error messages are displayed
    expect(find.text('Invalid email'), findsOneWidget);
  });
}
