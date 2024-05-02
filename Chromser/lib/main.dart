import 'package:Chromser/Repositeries/firebase_repository.dart';
import 'package:Chromser/Screens/classifications/HomeScreen.dart';
import 'package:Chromser/Screens/LoginScreen.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/search_screen.dart';
import 'package:Chromser/Screens/classifications/chat/provider/Image_uploader.dart';
import 'package:Chromser/Screens/classifications/chat/provider/user_provider.dart';
import 'package:Chromser/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/home_screen.dart' as hm;

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyHomePage());
}

//keytool -list -v -keystore C:\Users\nikhil\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    // Firestore.instance.collection("users").document().setData({"name":"nkr_programmer"});
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: "Chromser",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(brightness: Brightness.dark),
          home: FutureBuilder(
            future: _repository.getCurrentUser(),
            builder: (context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                return hm.HomeScreen();
              } else {
                return LoginScreen();
              }
// when current user is clicked if null then loginscreen else homescreen
            },
          )),
    );
  }
}

// FUTURE BUILDER IS THERE IN GOOGLE  SIGN IN ONLY

//error resolution
//1. srinker error or settining.dart :thats because add lines in android/app/setting.dart 
//and  this line in app/build.gradle multiDexEnabled true &&    this one also
//implementation 'com.android.support:multidex:1.0.3'  //with support libraries
//not this one this is in  //implementation 'androidx.multidex:multidex:2.0.1'  //with androidx libraries 
//for console test mode increase the time limit and for normal mode change false to true