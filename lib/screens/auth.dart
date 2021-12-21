import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/widgets/auth/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(
      String email,
      String username,
      String password,
      File userImageFile,
      bool isLogin,
      BuildContext ctx,
      ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(userCredential.user!.uid+".jpg");

        await ref.putFile(userImageFile).whenComplete(() async {

          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance.collection("users")
              .doc(userCredential.user?.uid)
              .set({
            'username':username,
            'email':email,
            'imageUrl': url,
          });

        });


      }


    } on PlatformException catch(err){
      var msg = "An Error occurred, Please Check your credentials!";
      
      if(err.message!=null){
        msg = err.message!;
      }
      
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading =false;
      });
    } catch (err){
      print(err);
      setState(() {
        _isLoading=false;
      });
    }
    
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
