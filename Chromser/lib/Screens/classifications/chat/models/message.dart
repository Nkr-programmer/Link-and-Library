import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
 late String senderId;
 late String receiverId;
 late String type;
 late String message;
 late Timestamp timestamp;
 late String photoUrl;

Message({required this.senderId,required this.receiverId,required this.type,required this.message,required this.timestamp});
Message.imageMessage({required this.senderId,required this.receiverId,required this.message,required this.type,required this.timestamp,required this.photoUrl});
Message.pdfMessage({required this.senderId,required this.receiverId,required this.message,required this.type,required this.timestamp,required this.photoUrl});




Map<String,dynamic> toMap(){
Map<String,dynamic> map = Map<String,dynamic>();
map["senderId"]=this.senderId;
map["receiverId"]=this.receiverId;
map["type"]=this.type;
map["message"]=this.message;
map["timestamp"]=this.timestamp;
return map;

}


Map<String,dynamic> toImageMap(){
Map<String,dynamic> map = Map<String,dynamic>();
map["senderId"]=this.senderId;
map["receiverId"]=this.receiverId;
map["type"]=this.type;
map["message"]=this.message;
map["timestamp"]=this.timestamp;
map["photoUrl"]= this.photoUrl;
return map;

}

Map<String,dynamic> topdfMap(){
Map<String,dynamic> map = Map<String,dynamic>();
map["senderId"]=this.senderId;
map["receiverId"]=this.receiverId;
map["type"]=this.type;
map["message"]=this.message;
map["timestamp"]=this.timestamp;
map["photoUrl"]= this.photoUrl;
return map;

}

Message.fromMap(Map<String,dynamic> map){
 
    this.senderId=map["senderId"];
    this.receiverId=map["receiverId"];
    this.type=map["type"];
    this.message=map["message"];
    this.timestamp=map["timestamp"];
    this.photoUrl=map["photoUrl"]==null?'':map["photoUrl"];
  }


}