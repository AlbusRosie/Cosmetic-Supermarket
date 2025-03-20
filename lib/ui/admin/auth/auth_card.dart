import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/colors.dart';
import '../shared/dialog_utils.dart';
import 'auth_manager.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'username': '',
    'email': '',
    'phone': '',
    'password': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _isSubmitting.value = true;

    print('✅ Auth data after save: $_authData');

    try {
      if (_authMode == AuthMode.login) {
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
      } else {
        await context.read<AuthManager>().signup(
              _authData['username']!,
              _authData['email']!,
              _authData['phone']!,
              _authData['password']!,
            );
        _switchAuthMode();
      }
    } catch (error) {
      log('$error');
      if (mounted) {
        showErrorDialog(context, error.toString());
      }
    }
    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.login ? AuthMode.signup : AuthMode.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Container(
            width: double.infinity,
            height: size.height * 0.75,
            decoration: const BoxDecoration(
              color: color17,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    _authMode == AuthMode.signup
                        ? "Register new account!"
                        : "Login to your account!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 25,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: color4,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildEmailField(),
                        if (_authMode == AuthMode.signup) ...[
                          _buildUsernameField(),
                          _buildPhoneField(),
                        ],
                        _buildPasswordField(),
                        if (_authMode == AuthMode.signup) ...[
                          _buildPasswordConfirmField(),
                        ],
                        ValueListenableBuilder<bool>(
                          valueListenable: _isSubmitting,
                          builder: (context, isSubmitting, child) {
                            return isSubmitting
                                ? const CircularProgressIndicator()
                                : _buildSubmitButton();
                          },
                        ),
                        _buildAuthModeSwitchButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return _buildTextField(
      hintText: "Username",
      icon: Icons.person,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Username cannot be blank!';
        }
        return null;
      },
      onSaved: (value) => _authData['username'] = value!, 
    );
  }

  Widget _buildPhoneField() {
    return _buildTextField(
      hintText: "Phone",
      icon: Icons.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone cannot be blank!';
        }
        return null;
      },
      onSaved: (value) => _authData['phone'] = value!,
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      hintText: "Email",
      icon: Icons.email,
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) => _authData['email'] = value!,
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      hintText: "Password",
      icon: Icons.lock,
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) => _authData['password'] = value!,
    );
  }

  Widget _buildPasswordConfirmField() {
    return _buildTextField(
      hintText: "Confirm Password",
      icon: Icons.lock_reset,
      obscureText: true,
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Passwords do not match!';
        }
        return null;
      },
    );
  }

  Widget _buildAuthModeSwitchButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _authMode == AuthMode.login
              ? "Does not have any account?"
              : "Already have an account?",
          style: TextStyle(
            color: color4,
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: _switchAuthMode,
          child: Text(
            _authMode == AuthMode.login ? 'Register here' : 'Login here',
            style: TextStyle(
              color: color4,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: size.width * 0.8,
      height: 55,
      decoration: BoxDecoration(
        color: color4,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextButton(
        onPressed: _submit,
        child: Text(
          _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP',
          style: TextStyle(color: color13, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: color1,
        style: const TextStyle(height: 1, fontSize: 16),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: color1,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: color1),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: color13,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color4, width: 1.5),
      ),
      child: child
    );
  }
}