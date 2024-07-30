import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationException implements Exception {
  final String type;
  final String message;

  AuthenticationException(this.type, this.message);

  @override
  String toString() => 'AuthenticationException(type: $type, message: $message)';
}

// todo maybe
String buildDeviceInfo() {
  return jsonEncode({
    "available": true,
    "platform": "Android",
    "version": "14",
    "uuid": "h",
    "cordova": "12.0.1",
    "model": "Android SDK built for x86_64",
    "manufacturer": "unknown",
    "isVirtual": false,
    "serial": "unknown",
    "isiOSAppOnMac": null,
    "sdkVersion": 34,
    "appVersion": "12.11"
  });
}

Future<Map<String, dynamic>> firstSignIn(
  String email,
  String password,
) async {
  // building a request
  final url = Uri.parse("https://mobidziennik.pl/logowanieapp");

  final deviceInfo = buildDeviceInfo();

  final body = {
    "api2": "true",
    "email": email,
    "haslo": password,
    "hash": "true",
    "device": deviceInfo,
  };

  // sending the request
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: body,
  );

  // handle the response
  if (response.statusCode != 200) {
    throw Exception('Failed to sign in. Status code: ${response.statusCode}');
  }

  final payload = jsonDecode(response.body);

  if (payload.containsKey("error")) {
    final error = payload['error'];
    final type = error['type'];
    final message = error['message'];

    throw AuthenticationException(type, message);
  }

  return payload;
}

enum Page {
  Login("login");

  const Page(this.page);
  final String page;
}

Future<Map<String, dynamic>> _sync(
  String syncUrl,
  String login,
  String email,
  String password,
  Page page
) async {
  final url = Uri.parse(syncUrl);

  final deviceInfo = buildDeviceInfo();

  final body = {
    "login": login,
    "email": email,
    "haslo_hash": "",
    "page": page.page,
    "haslo": password,
    "device": deviceInfo,
  };

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: body,
  );

  // handle the response
  if (response.statusCode != 200) {
    throw Exception('Failed to sign in. Status code: ${response.statusCode}');
  }

  final payload = jsonDecode(response.body);

  if (payload.containsKey("error")) {
    final error = payload['error'];
    final type = error['type'];
    final message = error['message'];

    throw AuthenticationException(type, message);
  }

  return payload;
}

Future<Map<String, dynamic>> firstSync(
  String syncUrl,
  String login,
  String email,
  String password,
) async {
  return _sync(syncUrl, login, email, password, Page.Login);
}