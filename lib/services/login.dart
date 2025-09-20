import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class TokenResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String refreshToken;

  TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      refreshToken: json['refresh_token'],
    );
  }
}

class ApiService {
  static Future<TokenResponse> loginToKreta({
    required String userName,
    required String password,
    required String instituteCode,
  }) async {
    final cookieJar = <String, String>{};

    Future<http.Response> makeRequest(Uri url,
        {String method = 'GET', Map<String, String>? headers, Object? body}) async {
      final requestHeaders = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
        if (cookieJar.isNotEmpty)
          'Cookie': cookieJar.entries.map((e) => '${e.key}=${e.value}').join('; '),
        if (headers != null) ...headers,
      };

      http.Response response;
      if (method == 'GET') {
        response = await http.get(url, headers: requestHeaders);
      } else {
        response = await http.post(url, headers: requestHeaders, body: body);
      }

      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        for (var cookie in setCookie.split(',')) {
          final parts = cookie.split(';').first.split('=');
          if (parts.length == 2) cookieJar[parts[0].trim()] = parts[1].trim();
        }
      }

      return response;
    }

    final initialUrl = Uri.parse(
        'https://idp.e-kreta.hu/Account/Login?ReturnUrl=%2Fconnect%2Fauthorize%2Fcallback%3Fprompt%3Dlogin');
    final initialResponse = await makeRequest(initialUrl);
    if (initialResponse.statusCode != 200) {
      throw Exception('Failed to fetch login page: ${initialResponse.statusCode}');
    }

    final doc = html_parser.parse(initialResponse.body);
    final tokenInput = doc.querySelector('input[name="__RequestVerificationToken"]');
    if (tokenInput == null) throw Exception('RequestVerificationToken not found');
    final rvt = tokenInput.attributes['value'] ?? '';

    final loginPayload = {
      'ReturnUrl': '/connect/authorize/callback?prompt=login',
      'IsTemporaryLogin': 'false',
      'UserName': userName,
      'Password': password,
      'InstituteCode': instituteCode,
      'loginType': 'InstituteLogin',
      '__RequestVerificationToken': rvt,
    };

    await Future.delayed(const Duration(milliseconds: 500));

    final loginResponse = await makeRequest(
      Uri.parse('https://idp.e-kreta.hu/account/login'),
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: loginPayload.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&'),
    );

    if (loginResponse.statusCode != 302 &&
        loginResponse.statusCode != 200) {
      throw Exception('Login failed: ${loginResponse.statusCode}');
    }

    final authUrl = Uri.parse(
        'https://idp.e-kreta.hu/connect/authorize/callback?prompt=login');
    final authResponse = await makeRequest(authUrl, method: 'GET');
    final location = authResponse.headers['location'];
    if (location == null) throw Exception('No redirect location found');

    final uri = Uri.parse(location);
    final code = uri.queryParameters['code'];
    if (code == null) throw Exception('Authorization code not found');

    final tokenPayload = {
      'code': code,
      'code_verifier': 'DSpuqj_HhDX4wzQIbtn8lr8NLE5wEi1iVLMtMK0jY6c',
      'redirect_uri':
          'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect',
      'client_id': 'kreta-ellenorzo-student-mobile-ios',
      'userName': userName,
      'password': password,
      'institute_code': instituteCode,
      'grant_type': 'authorization_code',
    };

    final tokenResponse = await http.post(
      Uri.parse('https://idp.e-kreta.hu/connect/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: tokenPayload.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'),
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception('Token exchange failed: ${tokenResponse.statusCode}');
    }

    final tokens = TokenResponse.fromJson(jsonDecode(tokenResponse.body));
    return tokens;
  }
}
