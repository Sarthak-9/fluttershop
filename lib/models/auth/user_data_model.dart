import 'dart:io';

import 'package:flutter/material.dart';

class UserDataModel {
  // final String userFId;
  final String userEmail;
  final String userPhone;
  final String userName;
  final int userRole;
  UserDataModel(
      {
        // this.userFId,
        @required this.userEmail,
        @required this.userPhone,
        @required this.userName,
        this.userRole,
        });
}