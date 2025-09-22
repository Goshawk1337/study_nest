import 'package:get/get.dart';

class AuthController extends GetxController {
  var accessToken = RxnString();
  var refreshToken = RxnString();
  var instituteCode = RxnString();
  var expiry = Rxn<DateTime?>(null);

  bool get isLoggedIn {
    if (accessToken.value == null || expiry.value == null) return false;
    return DateTime.now().isBefore(expiry.value!);
  }

  void login({
    required String accessToken,
    required String refreshToken,
    required String instituteCode,
    required int expiresInSeconds,
  }) {
    this.accessToken.value = accessToken;
    this.refreshToken.value = refreshToken;
    this.instituteCode.value = instituteCode;
    expiry.value = DateTime.now().add(Duration(seconds: expiresInSeconds));
  }

  void logout() {
    accessToken.value = null;
    refreshToken.value = null;
    instituteCode.value = null;
    expiry.value = null;
  }
}
