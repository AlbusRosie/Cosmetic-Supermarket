import 'package:flutter/foundation.dart';
import '../../../models/user.dart';
import '../../../services/user_service.dart';

class UserManager with ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];

  List<User> get customers => [..._users];

  Future<void> fetchUsers({String? category}) async {
    _users = await _userService.fetchUsers();
    notifyListeners();
  }
}
