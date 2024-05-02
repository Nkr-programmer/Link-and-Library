import 'dart:io';

import 'dart:typed_data';

import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Screens/classifications/chat/models/message.dart';
import 'package:Chromser/Screens/classifications/chat/provider/Image_uploader.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/chat_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';




class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //user class
  User? user;

  Future<String?> uploadImageToStorage(List<int> imageFile, String name) async {
    // mention try catch later on

    try {
      FirebaseStorage storage=FirebaseStorage.instance;
      Reference? reference;
      reference = storage.ref().child(name);
      Uint8List asset = Uint8List.fromList(imageFile);
      UploadTask uploadTask = reference.putData(asset);
      String url = await uploadTask.then((res) {
        return res.ref.getDownloadURL();
      });
      return url;
    } catch (e) {
      print(e.toString()+"errrrrrrrror");
      return null;
    }
  }
     Future<String?> uploadPdfToStorage(List<int> assets, String name)async{
        try {
            FirebaseStorage storage=FirebaseStorage.instance;
            Reference? reference;
            reference = storage.ref().child(name);
            Uint8List asset = Uint8List.fromList(assets);
            UploadTask uploadTask = reference.putData(asset);
            String url = await uploadTask.then((res) {
              return res.ref.getDownloadURL();
            });
            print(url.toString()+"duuuuuuuuuude");
            return url;
        } catch (e) {print(e.toString()+"errrrrr");  return null;}
  }

  void uploadImage({
    required Message message,
    required List<int>? image,
    required User? receiver,
    required User? sender,
    required ImageUploadProvider? imageUploadProvider,
    required int num,
    required String text,
    required String fileName,
    required User? author
  }) async {
    final ChatMethods chatMethods = ChatMethods();
    // Set some loading value to db and show it to user
    imageUploadProvider!.setToLoading();
    // Get url from the image bucket
    print(image.toString()+"messsssss");
    String? url = await uploadImageToStorage(image!, fileName);
    print(url.toString()+"urrrrrrrrrl");
    // Hide loading
    imageUploadProvider.setToIdle();
    message.photoUrl=url!;
    chatMethods.setImageMsg(message, receiver, sender,num,text,author);
  }
    void uploadPdf({
    required Message message,
    required List<int>? pdf,
    required User? receiver,
    required User? sender,
    required ImageUploadProvider? imageUploadProvider,
    required int num,
    required String text,
    required String fileName,
    required User? author
  }) async {
    final ChatMethods chatMethods = ChatMethods();
    // Set some loading value to db and show it to user
    imageUploadProvider!.setToLoading();
    // Get url from the image bucket
    String? url = await uploadPdfToStorage(pdf!,fileName);
    print(url.toString()+"givvvvvve");
    // Hide loading
    imageUploadProvider.setToIdle();
    message.photoUrl=url!;
    chatMethods.setPdfMsg(message, receiver, sender,num,text,author);
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