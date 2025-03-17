import 'package:pocketbase/pocketbase.dart';
import '../models/user.dart';
import 'pocketbase_client.dart';

class AuthService {
  void Function(User? user)? onAuthChange;

  AuthService({this.onAuthChange}) {
    _initPocketBase();
  }

  Future<void> _initPocketBase() async {
    try {
      final pb = await getPocketbaseInstance();
      if (pb == null) {
        print('Error: PocketBase instance is null!');
        return;
      }
      pb.authStore.onChange.listen((event) {
        if (onAuthChange != null) {
          onAuthChange!(event.record == null
              ? null
              : User.fromJson(event.record!.toJson()));
        }
      });
    } catch (error) {
      print('Error initializing PocketBase: $error');
    }
  }

  Future<User> signup(
      String username, String email, String phone, String password) async {
    final pb = await getPocketbaseInstance();
    if (pb == null) {
      throw Exception("PocketBase not initialized. Please restart the app.");
    }

    try {
      // Check if the phone number already exists
      final existingUsers = await pb.collection('users').getList(
            filter: 'phone = "$phone"',
          );

      if (existingUsers.items.isNotEmpty) {
        throw Exception(
            "Phone number already exists! Please use a different one.");
      }

      print('Creating user: $email');

      final record = await pb.collection('users').create(body: {
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'passwordConfirm': password,
        'urole': 'customer', // Default role
      });

      print('PocketBase response: ${record.toJson()}');

      // Add email to the returned data
      Map<String, dynamic> userData = record.toJson();
      userData['email'] = email;

      return User.fromJson(userData);
    } catch (error) {
      print('Signup error details: $error');
      if (error is ClientException) {
        print('PocketBase error response: ${error.response}');
        final errorMessage = error.response['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
      throw Exception('An error occurred during registration');
    }
  }

  Future<User> login(String email, String password) async {
    final pb = await getPocketbaseInstance();
    if (pb == null) {
      throw Exception("PocketBase not initialized. Please restart the app.");
    }

    try {
      final authRecord =
          await pb.collection('users').authWithPassword(email, password);
      return User.fromJson(authRecord.record.toJson());
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred during login');
    }
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    if (pb != null) {
      pb.authStore.clear();
    }
  }

  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    if (pb == null) {
      return null;
    }

    final model = pb.authStore.record;
    if (model == null) {
      return null;
    }
    return User.fromJson(model.toJson());
  }
}
