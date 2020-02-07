import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';


class UserModel extends Model {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrenUser();
  }

  void singUp({@required Map<String, dynamic> userData,@required String pass,@required VoidCallback onSuccess,@required VoidCallback onFail }){
    isLoading = true;
    notifyListeners();
    
    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user) async{
      firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
        onFail();
        isLoading = false;
        notifyListeners();
    });
  }
  void singIn({@required String email,@required String pass,
      @required VoidCallback onSucess,@required VoidCallback onFaild}) async {
    isLoading = true;
    notifyListeners();

    await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass
    ).then((user) async{
      firebaseUser = user;
      await _loadCurrenUser();

      onSucess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){
      firebaseUser = null;
      onFaild();
      isLoading = false;
      notifyListeners();

    });
  }
  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  void singOut() {
    _auth.signOut();
    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  Future<Null> _loadCurrenUser() async {
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser =
            await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

}