import 'package:cloud_firestore/cloud_firestore.dart';

class Name{
  String senderId;
  String receiverId;
  String type;
Timestamp timestamp;


Name({this.senderId,this.receiverId,this.type,this.timestamp});



Map toMap(){
var map = Map<String,dynamic>();
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