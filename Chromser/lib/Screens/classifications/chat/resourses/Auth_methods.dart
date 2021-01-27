import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:Chromser/Screens/classifications/chat/constants/strings.dart';
import 'package:Chromser/Screens/classifications/chat/enum/user_state.dart';
import 'package:Chromser/Screens/classifications/chat/models/libraryname.dart';
import 'package:Chromser/Screens/classifications/chat/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class AuthMethods {
  static final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  FirebaseMethods _repository = FirebaseMethods();
  static final CollectionReference _userCollection =  _firestore.collection(USERS_COLLECTION);

 

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

try{     DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);}
    catch(e){
      print(e);
      return null;
    }
  }
  Future<User> getUserDetailsbyId(id) async {
try{  DocumentSnapshot documentSnapshot =
        await _userCollection.document(id).get();

    return User.fromMap(documentSnapshot.data);}
    catch(e){
      print(e);
      return null;
    }
  
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }
    Future<Name> fetchLibrariesReceiver(String _currentUserId,String text) async {
    Name userList = Name();
    QuerySnapshot querySnapshots ;
 
   querySnapshots=await firestore.collection("Private").document("name").collection(_currentUserId).getDocuments();
print(querySnapshots.documents.length);
    for (var i = 0; i < querySnapshots.documents.length; i++) { 
          if((Name.fromMap( querySnapshots.documents[i].data).senderId==_currentUserId||Name.fromMap( querySnapshots.documents[i].data).receiverId==_currentUserId)&&Name.fromMap( querySnapshots.documents[i].data).type==text)
        {print(Name.fromMap( querySnapshots.documents[i].data));userList=Name.fromMap( querySnapshots.documents[i].data);break;}
    }
    
    return userList;
  }
    Future<List<Name>> fetchAllLibraries(User sender, User receiver,num) async {
    List<Name> userList = List<Name>();
    QuerySnapshot querySnapshots ;
 
      if(num==1) { querySnapshots=await firestore.collection("Private").document("name").collection(receiver.uid).getDocuments();}
  else if(num==2){ querySnapshots=await firestore.collection("Public").document("name").collection(receiver.uid).getDocuments();}
 

    for (var i = 0; i < querySnapshots.documents.length; i++) { 
        
        if(num==1){
          if(Name.fromMap( querySnapshots.documents[i].data).senderId==sender.uid||Name.fromMap( querySnapshots.documents[i].data).receiverId==sender.uid)
        userList.add(Name.fromMap( querySnapshots.documents[i].data));}
   else if(num==2){ userList.add(Name.fromMap( querySnapshots.documents[i].data));}
    }
    
    return userList;
  }
    Future<List<Name>> fetchAllLibrariesPublic(User sender, User receiver,num) async {
    List<Name> userList = List<Name>();
    List<Name> userList2 = List<Name>();
    QuerySnapshot querySnapshots ;
      QuerySnapshot querySnapshots2 ;
  
     if(num==1){
 querySnapshots=await firestore.collection("Public").document("name").collection(sender.uid).getDocuments();
     }
     else if (num==2){
querySnapshots2=await firestore.collection("Private").document("name").collection(sender.uid).getDocuments();
}
 else if (num==3){
querySnapshots2=await firestore.collection("Individual").document("name").collection(sender.uid).getDocuments();

  }
int t=num==1?querySnapshots.documents.length:querySnapshots2.documents.length;
    for (var i = 0; i < t; i++) { 
        
        if(num==2){
          if(Name.fromMap( querySnapshots2.documents[i].data).senderId==sender.uid||Name.fromMap( 
            querySnapshots2.documents[i].data).receiverId==sender.uid)
        userList2.add(Name.fromMap( querySnapshots2.documents[i].data));}
   else if(num==1){ userList.add(Name.fromMap( querySnapshots.documents[i].data));}
   else if(num==3){userList2.add(Name.fromMap( querySnapshots2.documents[i].data));}
    }
   
    return num==2||num==3?userList2:userList;
  }

  Future<bool> signOut() async {
  try{
      await _googleSignIn.signOut();
   await _auth.signOut();
    return true;
  }
  catch(e){
    return false;
  }
  }
void setUserState({@required String userId,@required UserState userState}){
  int stateNum= Utilities.stateToNum(userState);
  _userCollection.document(userId).updateData({"state":stateNum});
}

Stream<DocumentSnapshot>getUserStream({@required String uid})=>_userCollection.document(uid).snapshots();
}
