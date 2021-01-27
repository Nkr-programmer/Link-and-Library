import 'package:Chromser/Repositeries/firebase_repository.dart';
import 'package:Chromser/Screens/classifications/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 FirebaseRepository _repository = FirebaseRepository();
 bool isLoginPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body:Stack(children:[ Center(child: loginButton()
      ),
      isLoginPressed?Center(child: CircularProgressIndicator(),):Container()
      ]),
    );
  }
   Widget loginButton(){
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey,
          child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text("Login",
        style: TextStyle(fontSize: 35,fontWeight: FontWeight.w700,letterSpacing: 1.2),),
        onPressed: () => performLogin(),
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))
            ),
    );
        }   
 void    performLogin() {

 print("trying to login");
 setState(() {
   isLoginPressed=true;
 });

   _repository.signIn().then((FirebaseUser user) {
if(user != null){
  authenticateUser(user);
}else{
  print("There was an error");
}
//directly signin
// from clicked email id ans=dd user hve all that details
   });
 }
 void authenticateUser(FirebaseUser user)
{
_repository.authenticateUser(user).then((isNewUser) {
  setState(() {
    isLoginPressed=false;
  });
  if(isNewUser){
    _repository.addDataToDb(user).then((value){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  return HomeScreen();
  },));});
  }
  else{
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  return HomeScreen();
  },));
  }
});
}}
// LOGINBUTTON=>PERFORMSIGNIN=>AUTHENTICATEUSER   USED IN SIGN IN DIRECTLY OR MAY BE FULL LOGINSCREEN
