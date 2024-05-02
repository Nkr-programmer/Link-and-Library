import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository
{

FirebaseMethods _firebaseMethods=FirebaseMethods();
  //1
   Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();
//take the current signed in emailid from methods and taken as function
//2
 Future<User?> signIn() => _firebaseMethods.signIn();
//this returns all user data or email that we have clicked
//3
Future<bool> authenticateUser(User user)=> _firebaseMethods.authenticateUser(user);
//true if new to register else false
//4
Future<void> addDataToDb(User user)=> _firebaseMethods.addDataToDb(user);
//FROM 1 TO 4 GOOGLE SIGNIN




}