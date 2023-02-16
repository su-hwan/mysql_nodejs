class API{
  static const hostConnect  = "http://192.168.0.100:3000";
  static const hostConnectUser = "$hostConnect/users";

  static const signup = "$hostConnectUser/signup";
  static const login = "$hostConnectUser/login";
  static const validateEmail = "$hostConnectUser/valid_email";
}