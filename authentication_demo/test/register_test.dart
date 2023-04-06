import 'package:authentication_demo/src/features/auth/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget runRegisterScreen() {
  return const MaterialApp(home: RegisterScreen());
}

void main() {
  testWidgets('should register successfully', (WidgetTester tester) async {
    await tester.pumpWidget(runRegisterScreen());

    // Find the title
    expect(find.text("Register"), findsOneWidget);

    // Find the TextFormField for user name
    final nameField = find.byKey(const Key('nameField'));
    expect(nameField, findsOneWidget);

    // Enter a valid user name
    await tester.enterText(nameField, 'test_example');
    await tester.pump();

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

    // Find the TextFormField for confirm password
    final conPassField = find.byKey(const Key('confirmPassField'));
    expect(conPassField, findsOneWidget);

    // Enter a valid confirm password
    await tester.enterText(conPassField, 'password123');
    await tester.pump();

    // Find the checkbox for service term argeement
    final checkbox = find.byKey(const Key("checkboxField"));
    expect(checkbox, findsOneWidget);

    // Tap the checkbox
    await tester.tap(checkbox);
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
    await tester.pumpWidget(runRegisterScreen());

    // Find the Submit button
    final submitButton = find.text('Submit');

    // Tap the Submit button
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Check if validation error messages are displayed
    expect(find.text('Field is required'), findsNWidgets(5));
  });

  testWidgets('should show invalid fields', (WidgetTester tester) async {
    await tester.pumpWidget(runRegisterScreen());

    // Find the TextFormField for user name
    final nameField = find.byKey(const Key('nameField'));

    // Enter a valid user name
    await tester.enterText(nameField, 'test example');
    await tester.pump();

    // Find the TextFormField for email
    final emailField = find.byKey(const Key('emailField'));

    // Enter a valid email address
    await tester.enterText(emailField, 'test@example');
    await tester.pump();

    // Find the TextFormField for password
    final passwordField = find.byKey(const Key('passField'));

    // Enter a valid password
    await tester.enterText(passwordField, 'pass');
    await tester.pump();

    // Find the TextFormField for confirm password
    final conPassField = find.byKey(const Key('confirmPassField'));

    // Enter a valid confirm password
    await tester.enterText(conPassField, '123');
    await tester.pump();

    // Find the Submit button
    final submitButton = find.text('Submit');

    // Tap the Submit button
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Check if validation error messages are displayed
    expect(
        find.text(
            'Username only contains a-z, 0-9, underscore and minimun length is 5 characters'),
        findsOneWidget);
    expect(find.text('Invalid email'), findsOneWidget);
    expect(find.text('Password length must at least 6 characters'),
        findsOneWidget);
    expect(find.text('Password is not match'), findsOneWidget);
    expect(find.text('Field is required'), findsOneWidget);
  });
}
