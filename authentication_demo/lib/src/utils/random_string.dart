import 'dart:math';

String generateRandomString(int strLength) {
  final random = Random.secure();
  const allChars =
      'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';

  final result = List.generate(
      strLength, (index) => allChars[random.nextInt(allChars.length)]).join();

  return result;
}
