import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:flutter/cupertino.dart';


class UserProvider with ChangeNotifier{
  User? _user;
  AuthMethods _authMethods= AuthMethods();
  User? get getUser=>_user;
  Future<void> refreshUser() async{
User? user = await _authMethods.getUserDetails();
_user=user!;
notifyListeners();
  }
}