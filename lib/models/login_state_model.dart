class LoginStateModel {
  String localId;
  String email;
  String displayName;
  String idToken;
  bool registered;
  String refreshToken;
  String expiresIn;
  bool isLoggedIn;

  LoginStateModel(
      {required this.localId,
      required this.email,
      required this.displayName,
      required this.idToken,
      required this.registered,
      required this.refreshToken,
      required this.expiresIn,
      required this.isLoggedIn});
}
