import 'package:mobidziennikowy_sdk/sdk.dart';

Future<void> main() async {
  final email = "";
  final pass = "";
  try {
    final result = await firstSignIn(email, pass);
    print('Sign-in successful: $result');
  } catch (e) {
    print('Error: $e');
  }
}
