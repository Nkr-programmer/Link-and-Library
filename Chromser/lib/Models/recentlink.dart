import 'package:cloud_firestore/cloud_firestore.dart';

class RecentMessage{
   int index;
   String name;
   String brand;
   String url;
   Timestamp addedOn;
   int number;
   String image;

  RecentMessage({this.index,this.name,this.brand,this.url,this.addedOn
  ,this.number,this.image});



  

Map<String,dynamic> toMap(){
Map<String,dynamic> recentMessageMap=Map();
recentMessageMap["link_index"]=this.index;
recentMessageMap["link_name"]=this.name;
recentMessageMap["link_brand"]=this.brand;
recentMessageMap["link_url"]=this.url;
recentMessageMap["link_addedOn"]=this.addedOn;
recentMessageMap["link_number"]=this.number;
recentMessageMap["link_image"]=this.image;

return recentMessageMap;}
RecentMessage.fromMap(Map recentMessageMap){
this.index=recentMessageMap["link_index"];
this.name=recentMessageMap["link_name"];
this.brand=recentMessageMap["link_brand"];
this.url=recentMessageMap["link_url"];
this.addedOn=recentMessageMap["link_addedOn"];
this.number=recentMessageMap["link_number"];
this.image=recentMessageMap["link_image"];
}

}