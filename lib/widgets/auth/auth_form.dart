import 'dart:io';

import 'package:building_a_chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitFn, required this.isLoading})
      : super(key: key);

  final bool isLoading;
  final void Function(String email, String password, String username,
      File? image, bool isLogin, BuildContext ctx) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(_userEmail, _userPassword.trim(), _userName.trim(),
          _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin)
                  UserImagePicker(
                    imagePickerFn: _pickedImage,
                  ),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup')),
                if (!widget.isLoading)
                  TextButton(
                      style: TextButton.styleFrom(primary: Colors.pink),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
