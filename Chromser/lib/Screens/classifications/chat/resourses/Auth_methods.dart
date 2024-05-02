import 'package:Chromser/Models/user.dart' as Users;
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
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseMethods _repository = FirebaseMethods();
  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<Users.User?> getUserDetails() async {
    Users.User? _user;
    User currentUser = await _repository.getCurrentUser();
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(currentUser.uid).get();
      _user = Users.User.fromMap(
          documentSnapshot.data() as Map<String, dynamic>);
      return _user;
    } catch (e) {
      print(e.toString()+"cvb");
      return _user;
    }
  }

  Future<Users.User> getUserDetailsbyId(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();

      return Users.User.fromMap(
          documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
      return Users.User(
          uid: id,
          name: '',
          email: '',
          username: '',
          status: '',
          state: -1,
          profilePhoto: '');
    }
  }

  Future<Users.User?> getUserDetailsbyIdForchatlist(id) async {
    Users.User? _user;
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      _user = Users.User.fromMap(
          documentSnapshot.data() as Map<String, dynamic>);
      return _user;
    } catch (e) {
      print(e.toString()+"cvb22");
      return _user;
    }
  }
  Future<List<Users.User>> fetchAllUsers(User currentUser) async {
    List<Users.User> userList = List<Users.User>.empty(growable: true);

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(Users.User.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
      }
    }
    return userList;
  }
    Future<List<Users.User>> fetchAllUsersForPublic() async {
    List<Users.User> userList = List<Users.User>.empty(growable: true);

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
        userList.add(Users.User.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
    }
    return userList;
  }

  Future<Name?> fetchLibrariesReceiver(
      String _currentUserId, String text) async {
    Name? userList;
    QuerySnapshot querySnapshots;

    querySnapshots = await firestore
        .collection("Private")
        .doc("name")
        .collection(_currentUserId)
        .get();
    print(querySnapshots.docs.length);
    for (var i = 0; i < querySnapshots.docs.length; i++) {
      if ((Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>)
                      .senderId ==
                  _currentUserId ||
              Name.fromMap(
                          querySnapshots.docs[i].data() as Map<String, dynamic>)
                      .receiverId ==
                  _currentUserId) &&
          Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>)
                  .type ==
              text) {
        print(Name.fromMap(
            querySnapshots.docs[i].data() as Map<String, dynamic>));
        userList =
            Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>);
        break;
      }
    }

    return userList;
  }

  Future<List<Name>> fetchAllLibraries(
      Users.User sender, Users.User receiver, num) async {
    List<Name> userList = List<Name>.empty(growable: true);
    QuerySnapshot? querySnapshots;

    if (num == 1) { querySnapshots = await firestore.collection("Private").doc("name").collection(receiver.uid).get();} 
    else if (num == 2) {querySnapshots = await firestore.collection("Public").doc("name").collection(receiver.uid).get();}
    for (var i = 0; i < querySnapshots!.docs.length; i++) {
      if (num == 1) {
        if (Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>).senderId ==sender.uid ||
            Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>).receiverId ==sender.uid)
          userList.add(Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>));
      } else if (num == 2) {
        userList.add(Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>));
      }
    }
    return userList;
  }

  Future<List<Name>> fetchAllLibrariesPublicforMineonly(
      Users.User? sender, Users.User? receiver) async {
    List<Name> userList = List<Name>.empty(growable: true);
    QuerySnapshot? querySnapshots;
    querySnapshots = await firestore
          .collection("Public")
          .doc("name")
          .collection(sender!.uid)
          .get();
    
    int t =  querySnapshots!.docs.length;
    for (var i = 0; i < t; i++) {
        if (Name.fromMap(querySnapshots!.docs[i].data() as Map<String, dynamic>).senderId == sender!.uid ||
            Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>).receiverId ==sender.uid)
              userList.add(Name.fromMap(querySnapshots.docs[i].data() as Map<String, dynamic>));
    }
    return userList;
  }

  Future<List<Name>> fetchAllLibrariesPublic(
      Users.User? sender, Users.User? receiver, num) async {
    List<Name> userList = List<Name>.empty(growable: true);
    List<Name> userList2 = List<Name>.empty(growable: true);
    List<QuerySnapshot?> querySnapshots = List<QuerySnapshot?>.empty(growable: true);
    QuerySnapshot? querySnapshots2;
    if (num == 1) {
      List<Users.User> allusers= await fetchAllUsersForPublic();
      print(allusers!.length);
       for(int i=0;i<allusers.length;i++)
       {
     QuerySnapshot? snapshots;
     snapshots = await firestore
          .collection("Public")
          .doc("name")
          .collection(allusers.elementAt(i).uid)
          .orderBy(TIMESTAMP_FIELD,)
          .get();
          if(snapshots.size!=0){querySnapshots.add(snapshots);}
       }
       print(querySnapshots.length.toString()+" ");
    } else if (num == 2) {
      querySnapshots2 = await firestore
          .collection("Private")
          .doc("name")
          .collection(sender!.uid)
          .get();
    } else if (num == 3) {
      querySnapshots2 = await firestore
          .collection("Individual")
          .doc("name")
          .collection(sender!.uid)
          .get();
    }
    int t =  num == 1 ? querySnapshots.length : querySnapshots2!.docs.length;
    for (var i = 0; i < t; i++) {
      if (num == 2) {
        if (Name.fromMap(querySnapshots2!.docs[i].data() as Map<String, dynamic>).senderId == sender!.uid ||
            Name.fromMap(querySnapshots2.docs[i].data() as Map<String, dynamic>).receiverId ==sender.uid)
              userList2.add(Name.fromMap(querySnapshots2.docs[i].data() as Map<String, dynamic>));
      } else if (num == 1) {
        for(int j=0;j<querySnapshots.elementAt(i)!.docs.length;j++)
        {
          print(querySnapshots.elementAt(i)!.docs[j].data().toString());
          userList.add(Name.fromMap(querySnapshots.elementAt(i)!.docs[j].data() as Map<String, dynamic>));
        }
      } else if (num == 3) {
        userList2.add(Name.fromMap(querySnapshots2!.docs[i].data() as Map<String, dynamic>));
      }
    }
    return num == 2 || num == 3 ? userList2 : userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = Utilities.stateToNum(userState);
    _userCollection.doc(userId).update({"state": stateNum});
  }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      _userCollection.doc(uid).snapshots();
}
