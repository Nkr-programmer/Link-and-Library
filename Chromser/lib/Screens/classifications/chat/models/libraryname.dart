import 'package:cloud_firestore/cloud_firestore.dart';

class Name{
 late String senderId;
 late String receiverId;
 late String type;
late Timestamp timestamp;


Name({required this.senderId,required this.receiverId,required this.type,required this.timestamp});



Map<String,dynamic> toMap(){
Map<String,dynamic> map = Map<String,dynamic>();
map["senderId"]=this.senderId;
map["receiverId"]=this.receiverId;
map["type"]=this.type;
map["timestamp"]=this.timestamp;
return map;

}


Name.fromMap(Map<String,dynamic> map){
 
    this.senderId=map["senderId"];
    this.receiverId=map["receiverId"];
    this.type=map["type"];
    this.timestamp=map["timestamp"];
  }


}