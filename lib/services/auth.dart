import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Destiny2Toolbox/services/native.dart';
import 'package:Destiny2Toolbox/services/secrets.dart';
import 'package:http/http.dart' as http;

class AuthService {
  NativeIntegrationService _nativeService;
  String authCode;
  String accessToken;
  String refreshToken;
  static const BUNGIE_TOKEN_URL = 'https://www.bungie.net/platform/app/oauth/token/';
  static const BUNGIE_AUTH_URL = 'https://www.bungie.net/en/oauth/authorize';
  String _clientID;
  String _clientSecret;
  String _apiKey;
  final Secrets _secrets;

  StreamController<String> _controller;
  Stream<String> accessTokenStream;

  AuthService(this._nativeService, this._secrets) {
    _nativeService.addMethodHandler(NativeIntegrationService.AUTH_CALLBACK, (arg) => _handleAuthCode(arg));
    this._clientID = _secrets.clientID;
    this._clientSecret = _secrets.clientSecret;
    this._apiKey = _secrets.apiKey;
    _controller = new StreamController();
    accessTokenStream = _controller.stream.asBroadcastStream();
  }

  loginUser() {
    String url = BUNGIE_AUTH_URL + "?client_id=${_secrets.clientID}&response_type=code";
    this._nativeService.invokeNativeMethod(NativeIntegrationService.VIEW_URL_METHOD, {"url": url});
  }

  logoutUser() {
    this.authCode = null;
    this.accessToken = null;
    this.refreshToken = null;
    log("Logged out user");
    _controller.add(null);
  }

  _handleAuthCode(String code) {
    log("received auth code $code");
    this.authCode = code;
    getAccessToken();
  }

  getAccessToken() async {
    var headers = contructTokenRequestHeaders();
    var body = "grant_type=authorization_code&code=$authCode";
    var response = await http.post(BUNGIE_TOKEN_URL, headers: headers, body: body);
    if(response.statusCode == 200) {
      var decodedBody = jsonDecode(response.body);
      this.accessToken = decodedBody["access_token"];
      this.refreshToken = decodedBody["refresh_token"];
      log("access token: $accessToken");
      _controller.add(this.accessToken);
    } else {
      handleFailure(response);
    }
  }

  void handleFailure(http.Response response) {
    int code = response.statusCode;
    String body = response.body;
    log("Received non-success response from bungie auth server: $code - $body");
  }

  Map<String, String> constructAuthHeaders() {
    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "X-Api-Key": _secrets.apiKey
    };
    return headers;
  }

  Map<String, String> contructTokenRequestHeaders() {
    String encodedCredentials = base64Encode(utf8.encode("$_clientID:$_clientSecret"));
    Map<String, String> headers = {
      "Authorization": "Basic $encodedCredentials",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    return headers;
  }
}
