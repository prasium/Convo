import 'dart:io';

import 'package:convo/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      File userImageFile, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;

  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String? _userEmail = '', _userName = '', _userPass = '';
  var _userImageFile;

  void _pickedImage(File image){
    _userImageFile = image;
  }

  void _trySubmit() {
    final valid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if(_userImageFile==null && !_isLogin)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select an Image"),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }

    if (valid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail!.trim(),
        _userName!.trim(),
        _userPass!.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!_isLogin)
                  UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (val) {
                      if (val!.isEmpty || !val.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userEmail = val!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) {
                        if (val!.isEmpty || val.length < 4) {
                          return 'Username must be at least 4 characters long';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _userName = val!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userPass = val!;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Sign up a new account'
                          : 'Already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
