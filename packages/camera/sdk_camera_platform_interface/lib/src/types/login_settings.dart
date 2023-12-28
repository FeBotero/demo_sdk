class LoginSettings {
  String ip;
  int port;
  String userName;
  String password;
  Map<String, Object>? extra;

  LoginSettings(
      {required this.ip,
      required this.port,
      required this.userName,
      required this.password,
      this.extra});
}
