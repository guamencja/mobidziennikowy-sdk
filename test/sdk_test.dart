import 'package:mobidziennikowy_sdk/sdk.dart';

Future<void> main() async {
  final email = "";
  final pass = "";
  try {
    final result = await firstSignIn(email, pass);
    print('Sign-in successful: $result');
    final result2 = await firstSync(result['sync_url'], result['login'], email, pass);
    final user = result2['user'];
    print('First sync succesful:\n auth key: ${user["auth_key"]}\npassword hash: ${user["password_hash"]}');
  } catch (e) {
    print('Error: $e');
  }
}
