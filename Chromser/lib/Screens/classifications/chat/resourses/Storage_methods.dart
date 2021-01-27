import 'dart:io';

import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Screens/classifications/chat/models/message.dart';
import 'package:Chromser/Screens/classifications/chat/provider/Image_uploader.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/chat_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';




class StorageMethods {
  static final Firestore firestore = Firestore.instance;

  StorageReference _storageReference;

  //user class
  User user = User();

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }
     Future<String> uploadPdfToStorage(List<int> asset, String name)async{
        try {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
     print(url+"  hey dude");
       return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    @required Message message,
    @required File image,
    @required User receiver,
    @required User sender,
    @required ImageUploadProvider imageUploadProvider,
    @required int num,
    @required String text,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();
message.photoUrl=url;
    chatMethods.setImageMsg(message, receiver, sender,num,text);
  }
    void uploadPdf({
    @required Message message,
    @required List<int> pdf,
    @required User receiver,
    @required User sender,
    @required ImageUploadProvider imageUploadProvider,
    @required int num,
    @required String text,
    @required String fileName
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadPdfToStorage(pdf,fileName);

    // Hide loading
    imageUploadProvider.setToIdle();
message.photoUrl=url;
    chatMethods.setPdfMsg(message, receiver, sender,num,text);
  }
}


// class FirebaseRepositiory{

// FirebaseMethods _firebaseMethods= FirebaseMethods();

// Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

// Future<FirebaseUser> signIn() => _firebaseMethods.signIn();
// Future<User> getUserDetails()=>_firebaseMethods.getUserDetails();
// Future<bool> authenticateUser(FirebaseUser user)=> _firebaseMethods.authenticateUser(user);


// Future<void> addDataToOb(FirebaseUser user)=>_firebaseMethods.addDataToOb(user);
// Future<void> signOut()=> _firebaseMethods.signOut();






// Future<List<User>> fetchAllUsers(FirebaseUser user) =>_firebaseMethods.fetchAllUsers(user);

// //Future<User> fetchUserDetailById(String uid)=>_firebaseMethods.fetchUserDetailById(uid);


//   Future<void> addMessageToOb(Message message, User sender, User receiver) =>
// _firebaseMethods.addMessageToOb(message, sender, receiver);

  
// // void uploadImage({
// //   @required File image,
// //   @required String receiverId,
// //   @required String senderId,
// // })=>
// // FirebaseMethods.uploadImage(
// //   image,receiverId,senderId
// // );
// void uploadImage({
//   @required File image,
//   @required String receiverId,
//   @required String senderId,
//   @required ImageUploadProvider imageUploadProvider,
// })=>_firebaseMethods.uploadImage(image,receiverId,senderId,imageUploadProvider);

// }