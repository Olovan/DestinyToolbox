import 'dart:async';
import 'dart:convert';

import 'package:Destiny2Toolbox/services/native.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String authCode;
  String accessToken;
  String refreshToken;
  static const BUNGIE_TOKEN_URL = 'https://www.bungie.net/platform/app/oauth/token/';
  static const BUNGIE_AUTH_URL = 'https://www.bungie.net/en/oauth/authorize';
  final String _clientID;
  final String _clientSecret;
  Completer<String> _completer = Completer<String>();
  Future<String> accessTokenFuture;
  NativeIntegrationService _nativeService;


  AuthService(NativeIntegrationService nativeService, this._clientID, this._clientSecret) {
    nativeService.addMethodHandler(NativeIntegrationService.AUTH_CALLBACK, (arg) => _handleAuthCode(arg));
    this._nativeService = nativeService;
    this.accessTokenFuture = _completer.future;
  }

  loginUser() {
    String url = BUNGIE_AUTH_URL + "?client_id=$_clientID&response_type=code";
    this._nativeService.invokeNativeMethod(NativeIntegrationService.VIEW_URL_METHOD, {"url": url});
  }

  _handleAuthCode(String code) {
    this.authCode = code;
    getAccessToken();
  }

  getAccessToken() async {
    var headers = constructHeaders();
    var body = "grant_type=authorization_code&code=$authCode";
    var response = await http.post(BUNGIE_TOKEN_URL, headers: headers, body: body);
    if(response.statusCode == 200) {
      var decodedBody = jsonDecode(response.body);
      this.accessToken = decodedBody["access_token"];
      this.refreshToken = decodedBody["refresh_token"];
      print("access token: $accessToken");
      _completer.complete(this.accessToken);
    } else {
      handleFailure(response);
    }
  }

  void handleFailure(http.Response response) {
    int code = response.statusCode;
    String body = response.body;
    print("Received non-success response from bungie auth server: $code - $body");
  }

  Map<String, String> constructHeaders() {
    String encodedCredentials = base64Encode(utf8.encode("$_clientID:$_clientSecret"));
    Map<String, String> headers = {
      "Authorization": "Basic $encodedCredentials",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    return headers;
  }
}
