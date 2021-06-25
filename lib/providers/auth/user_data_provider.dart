import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttershop/models/auth/user_data_model.dart';

class UserData with ChangeNotifier {
  UserDataModel _userData;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  UserDataModel get userData => _userData;

  Future<void> addUser(UserDataModel newUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    // print(_userID);
    try {
      await firestoreInstance.collection("userdata").doc(_userID).set({
        'userEmail': newUser.userEmail,
        'userName': newUser.userName,
        'userPhone': newUser.userPhone,
        // != null
        // ? newUser.dateofBirth.toIso8601String()
        // : null,
        'userRole': newUser.userRole,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
      final user = UserDataModel(
        // userFId: _userID,
          userEmail: newUser.userEmail,
          userPhone: newUser.userPhone,
          userName: newUser.userName,
          userRole: 5,

      );
      _userData = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUser(UserDataModel updateUser) async {
    String photoUrl;
    var _userID = _auth.currentUser.uid;
    // var userFid = _userData.userFId;
    try {

      await firestoreInstance.collection("userdata").doc(_userID).update({
        'userPhone': updateUser.userPhone,
        // != null
        //       ? updateUser.dateofBirth.toIso8601String()
        //       : null,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      return;
    }
    _auth.currentUser.refreshToken;
    var _userID = _auth.currentUser.uid;

    final querySnapshot = await firestoreInstance.collection("userdata").doc(_userID).get(); //.then((querySnapshot) {
    // querySnapshot.docs
    //     .forEach((result) {
    UserDataModel _loadedUser = UserDataModel(
      // userFId: querySnapshot.id,
      userEmail: querySnapshot.data()["userEmail"],
      userPhone: querySnapshot.data()["userPhone"],
      userName: querySnapshot.data()["userName"],
      userRole:querySnapshot.data()["userRole"],//!=null? int.parse(result.data()["userRole"].toString()):null,
      // != null
      //   ? DateTime.parse(result.data()["userDOB"])
      //   : null,
    );
    // print(_loadedUser.userRole);
    // _loadedUser = user;
    // }
    // );
    _userData = _loadedUser;
  }

  Future<void> updateUserRole(int userRole)async{
    var _userID = _auth.currentUser.uid;
    // var userFid = _userData.userFId;
    try{
      await firestoreInstance.collection("userdata").doc(_userID).update({
        'userRole':userRole,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
    }catch(error){

    }
  }

}
