// A simple singleton class to hold the authenticated user's data
class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isUserLoggedIn => _currentUser != null;

  void login(Map<String, dynamic> userData) {
    _currentUser = userData;
  }

  void logout() {
    _currentUser = null;
  }
}
