import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth with ChangeNotifier {
  String? email;
  String? name;
  String? imageUrl;
  String? userId;

  String get getUserId {
    return userId!;
  }

  String get getName {
    return name!;
  }

  Future<void> authenticate(String email, String password, bool isLogin,
      [String name = 'name', File? profilePic]) async {
    final _auth = FirebaseAuth.instance;
    final _authResponse;
    final userData;
    print('EMAIL : $email');

    try {
      if (isLogin) {
        _authResponse = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(_authResponse.user?.uid);
        this.userId = _authResponse.user!.uid;
        userData = await FirebaseFirestore.instance
            .collection('users')
            .doc('${_authResponse.user.uid}')
            .get();
        this.email = email;
        this.name = userData['name'];
        this.imageUrl = userData['imageUrl'];
      } else {
        _authResponse = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        var url =
            'https://firebasestorage.googleapis.com/v0/b/exengg-e242e.appspot.com/o/profile_pics%2Fdefault.jpg?alt=media&token=31d7835e-7269-4587-8335-c6501d40491d';
        if (profilePic != null) {
          final ref = await FirebaseStorage.instance
              .ref()
              .child('profile_pics')
              .child(_authResponse.user!.uid);

          await ref.putFile(profilePic);
          url = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_authResponse.user!.uid)
            .set({'name': name, 'email': email, 'imageUrl': url});
        print(_authResponse.user?.uid);
        this.userId = _authResponse.user!.uid;
        userData = await FirebaseFirestore.instance
            .collection('users')
            .doc('${_authResponse.user.uid}')
            .get();
        this.email = email;
        this.name = userData['name'];
        this.imageUrl = userData['imageUrl'];
      }

      print('LOGIN SUCCESS NOW FETCHING USER DATA');

      // print();

      // json.decode(userData.data());
      print('FETCHED USER DATA');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  bool get isAuth {
    return userId != null && email != null && name != null && imageUrl != null;
  }

  void logOut() {
    print('logging out');
    FirebaseAuth.instance.signOut();
    userId = null;
    email = null;
    name = null;
    imageUrl = null;
    // notifyListeners();
  }

  Future<void> tryLogin() async {
    final currUser = FirebaseAuth.instance.currentUser;
    if (currUser != null) {
      final userData;
      try {
        userData = await FirebaseFirestore.instance
            .collection('users')
            .doc('${currUser.uid}')
            .get();
      } catch (error) {
        print('ERROR IS IS : ${error.toString()}');
        throw error;
      }
      String userDataToString = userData.data().toString();
      this.userId = userDataToString == 'null' ? null : currUser.uid;
      this.email = userDataToString == 'null' ? null : userData['email'];
      this.name = userDataToString == 'null' ? null : userData['name'];
      this.imageUrl = userDataToString == 'null' ? null : userData['imageUrl'];
    }
    // notifyListeners();
  }
}
