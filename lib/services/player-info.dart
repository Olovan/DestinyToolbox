import 'dart:convert';
import 'dart:developer';

import 'package:Destiny2Toolbox/models/Profile.dart';
import 'package:Destiny2Toolbox/services/auth.dart';
import 'package:http/http.dart' as http;

class PlayerInfoService {
  static const BASE_URL = 'https://www.bungie.net/Platform';
  static const GET_CURRENT_USER_URL = '$BASE_URL/User/GetMembershipsForCurrentUser/';

  Profile profile;

  AuthService authService;

  PlayerInfoService(this.authService);


  Future<Profile> getCurrentUserInfo() async => profile ?? await getCurrentUserInfoFromApi();

  Future<Profile> getCurrentUserInfoFromApi() async {
    var headers = this.authService.constructAuthHeaders();
    var response = await http.get(GET_CURRENT_USER_URL, headers: headers);
    if(response.statusCode == 200) {
      log("User Info: ${response.statusCode}\n${response.body}");
      var body = jsonDecode(response.body);
      var destinyInfo = body["Response"]["destinyMemberships"][0];
      profile = Profile(
        id: destinyInfo["membershipId"],
        name: destinyInfo["displayName"],
        type: destinyInfo["membershipType"],
      );
      return profile;
    } else {
      log("Received non-success response from Bungie API. Logging out user");
      authService.logoutUser();
      return null;
    }
  }
}