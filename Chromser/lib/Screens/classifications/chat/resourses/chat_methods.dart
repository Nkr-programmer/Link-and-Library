import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Screens/classifications/chat/constants/strings.dart';
import 'package:Chromser/Screens/classifications/chat/models/contact.dart';
import 'package:Chromser/Screens/classifications/chat/models/libraryname.dart';
import 'package:Chromser/Screens/classifications/chat/models/message.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);
  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);
  AuthMethods _authMethods = new AuthMethods();


  Future<void> addMessageToDb(
      Message message, User sender, User receiver, String text, int num) async {
  
  
    var map = message.toMap();
    Name name = Name(
      receiverId:
          num == 2 || num == 31 ? "" : num == 3 ? sender.uid : receiver.uid,
      senderId: sender.uid,
      type: text,
      timestamp: Timestamp.now(),
    );
    var maps = name.toMap();
//31 is mine public chats where as 32 is mine private chats
    await num == 2 || num == 31
        ? _firestore
            .collection("Public")
            .document(message.senderId)
            .collection(text)
            .add(map)
        : num == 3
            ? _firestore
                .collection("Individual")
                .document(message.senderId)
                .collection(text)
                .add(map)
            : _firestore
                .collection("Private")
                .document(message.senderId)
                .collection(message.receiverId)
                .document(text)
                .collection(text)
                .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);
    List<Name> names;
    int isthere = 0;
    // names=await _authMethods
    //     .fetchAllLibrariesPublic(sender, receiver, num);


    // ListView.builder(
    //     itemCount: names.length,
    //     itemBuilder: ((context, index) {
    //       if (names[index].type == text) {
    //         isthere = 1;
    //       }
    //     }));

    if (isthere == 0) {
      num == 2 || num == 31
          ? _firestore
              .collection("Public")
              .document("name")
              .collection(message.senderId)
              .add(maps)
          : num == 3
              ? _firestore
                  .collection("Individual")
                  .document("name")
                  .collection(message.senderId)
                  .add(maps)
              : {_firestore
                  .collection("Private")
                  .document("name")
                  .collection(message.receiverId)
                  .add(maps),_firestore
              .collection("Private")
              .document("name")
              .collection(message.senderId)
              .add(maps)};
      // num != 2 && num != 31 && num != 3
      //     ? _firestore
      //         .collection("Private")
      //         .document("name")
      //         .collection(message.senderId)
      //         .add(maps)
      //     : print("Done");
    }
    return await num != 2 && num != 31 && num != 3
        ? _firestore
            .collection("Private")
            .document(message.receiverId)
            .collection(message.senderId)
            .document(text)
            .collection(text)
            .add(map)
        : print("dne");
  }

  void setImageMsg(Message message, User receiver, User sender, int num,
      String text) async {


    // create imagemap
    var map = message.toImageMap();
    Name name = Name(
        receiverId:        num == 2 || num == 31 ? "" : num == 3 ? sender.uid : receiver.uid,
      senderId: sender.uid,
      type: text,
      timestamp: Timestamp.now(),
    );
    var maps = name.toMap();

    await num == 2|| num == 31
        ? _firestore
            .collection("Public")
            .document(message.senderId)
            .collection(text)
            .add(map)
                   : num == 3
            ? _firestore
                .collection("Individual")
                .document(message.senderId)
                .collection(text)
                .add(map)
        : _firestore
            .collection("Private")
            .document(message.senderId)
            .collection(message.receiverId)
            .document(text)
            .collection(text)
            .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);
    List<Name> names;
    int isthere = 0;
  //  names=await  _authMethods
  //       .fetchAllLibrariesPublic(sender, receiver, num);


  //   ListView.builder(
  //       itemCount: names.length,
  //       itemBuilder: ((context, index) {
  //         if (names[index].type == text) {
  //           isthere = 1;
  //         }
  //       }));
      
      
      if (isthere == 0) {
      num == 2 || num == 31? _firestore
            .collection("Public")
            .document("name")
            .collection(message.senderId)
            .add(maps)
        : num == 3
              ? _firestore
                  .collection("Individual")
                  .document("name")
                  .collection(message.senderId)
                  .add(maps)
              :{_firestore
            .collection("Private")
            .document("name")
            .collection(message.receiverId)
            .add(maps),_firestore
            .collection("Private")
            .document("name")
            .collection(message.senderId)
            .add(maps)};
    // num != 2&& num != 31 && num != 3
    //     ? _firestore
    //         .collection("Private")
    //         .document("name")
    //         .collection(message.senderId)
    //         .add(maps)
    //     : print("Done");
      }
num != 2 && num != 31 && num != 3
        ? _firestore
            .collection("Private")
            .document(message.receiverId)
            .collection(message.senderId)
            .document(text)
            .collection(text)
            .add(map)
        : print("dne");
  }
  
  void setPdfMsg(Message message, User receiver, User sender, int num,
      String text) async {
    // create imagemap
    var map = message.topdfMap();
    Name name = Name(
        receiverId:        num == 2 || num == 31 ? "" : num == 3 ? sender.uid : receiver.uid,
      senderId: sender.uid,
      type: text,
      timestamp: Timestamp.now(),
    );
    var maps = name.toMap();

    await num == 2|| num == 31
        ? _firestore
            .collection("Public")
            .document(message.senderId)
            .collection(text)
            .add(map)
                   : num == 3
            ? _firestore
                .collection("Individual")
                .document(message.senderId)
                .collection(text)
                .add(map)
        : _firestore
            .collection("Private")
            .document(message.senderId)
            .collection(message.receiverId)
            .document(text)
            .collection(text)
            .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);
    List<Name> names;
    int isthere = 0;
  //  names=await  _authMethods
  //       .fetchAllLibrariesPublic(sender, receiver, num);


  //   ListView.builder(
  //       itemCount: names.length,
  //       itemBuilder: ((context, index) {
  //         if (names[index].type == text) {
  //           isthere = 1;
  //         }
  //       }));
      
      
      if (isthere == 0) {
      num == 2 || num == 31? _firestore
            .collection("Public")
            .document("name")
            .collection(message.senderId)
            .add(maps)
        : num == 3
              ? _firestore
                  .collection("Individual")
                  .document("name")
                  .collection(message.senderId)
                  .add(maps)
              :{_firestore
            .collection("Private")
            .document("name")
            .collection(message.receiverId)
            .add(maps),_firestore
            .collection("Private")
            .document("name")
            .collection(message.senderId)
            .add(maps)};
    // num != 2&& num != 31 && num != 3
    //     ? _firestore
    //         .collection("Private")
    //         .document("name")
    //         .collection(message.senderId)
    //         .add(maps)
    //     : print("Done");
      }
num != 2 && num != 31 && num != 3
        ? _firestore
            .collection("Private")
            .document(message.receiverId)
            .collection(message.senderId)
            .document(text)
            .collection(text)
            .add(map)
        : print("dne");
  }

  DocumentReference getContactDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(CONTACTS_COLLECTION)
          .document(forContact);

  void addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSendersContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(uid: receiverId, addedOn: currentTime);

      var receiverMap = receiverContact.toMap(receiverContact);
      await getContactDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiversContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(uid: senderId, addedOn: currentTime);

      var senderMap = senderContact.toMap(senderContact);
      await getContactDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessagesBetween(
          {@required String senderId, @required String receiverId}) =>
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
