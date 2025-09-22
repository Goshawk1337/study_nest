import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebviewWidget extends StatefulWidget {
  final String? username;
  final String? schoolId;

  const LoginWebviewWidget({super.key, this.username, this.schoolId});

  @override
  State<LoginWebviewWidget> createState() => _LoginWebviewWidgetState();
}

class _LoginWebviewWidgetState extends State<LoginWebviewWidget> {
  late WebViewController _webViewController;

  late final String codeVerifier;
  late final String codeChallenge;
  late final String state;
  late final String nonce;

  static const String clientId = "kreta-ellenorzo-student-mobile-ios";
  static const String redirectUri = "https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect";
  static const String idpBase = "https://idp.e-kreta.hu";

  @override
  void initState() {
    super.initState();

    codeVerifier = _generateCodeVerifier();
    codeChallenge = _generateCodeChallenge(codeVerifier);
    state = _generateRandomString();
    nonce = _generateRandomString();

    var loginUrl = _buildLoginUrl(
      username: widget.username,
      schoolId: widget.schoolId,
    );

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final uri = Uri.parse(request.url);

            if (uri.path.endsWith("/ellenorzo-student/prod/oauthredirect")) {
              final code = uri.queryParameters["code"];
              if (code != null) {
                final token = await _exchangeCodeForToken(code);
                if (!mounted) return NavigationDecision.prevent;
                Navigator.of(context).pop(token);
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(loginUrl));
  }

  String _buildLoginUrl({String? username, String? schoolId}) {
    final base = "$idpBase/Account/Login?ReturnUrl=";
    final returnUrl =
        Uri.encodeComponent("/connect/authorize/callback?redirect_uri=$redirectUri"
            "&client_id=$clientId"
            "&response_type=code"
            "${username != null ? "&login_hint=$username" : ""}"
            "&prompt=login"
            "&state=$state"
            "&nonce=$nonce"
            "&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public"
            "%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public"
            "%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public"
            "&code_challenge=$codeChallenge"
            "&code_challenge_method=S256"
            "${schoolId != null ? "&institute_code=$schoolId" : ""}"
            "&suppressed_prompt=login");

    return "$base$returnUrl";
  }

  Future<Map<String, dynamic>> _exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse("$idpBase/connect/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "authorization_code",
        "client_id": clientId,
        "code": code,
        "redirect_uri": redirectUri,
        "code_verifier": codeVerifier,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to exchange token: ${response.body}");
    }
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll("=", "");
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll("=", "");
  }

  String _generateRandomString([int length = 16]) {
    final random = Random.secure();
    final bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return base64Url.encode(bytes).replaceAll("=", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kréta Login")),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}
