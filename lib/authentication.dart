import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/token_box.dart';

Future<String?> authenticateUser (String username, String password) async {
  final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/TokenAuth/Authenticate');

  final headers = <String, String> {
    'Abp.TenantId' : '10',
    'Content-Type' : 'application/json',
  };

  final body = jsonEncode({
    'userNameOrEmailAddress' : username,
    'password' : password
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final accessToken = jsonResponse['result']['accessToken'] as String;
      if (accessToken != null) {
        final tokenBox = TokenBox();
        await tokenBox.saveToken(accessToken);
        return accessToken;
      }
    }
  } catch (e) {
    print("Authentication Failed: $e");
  }

  return null;
}