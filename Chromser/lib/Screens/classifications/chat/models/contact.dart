import 'package:cloud_firestore/cloud_firestore.dart';


class Contact{
late String uid;
late Timestamp addedOn;
Contact({required this.uid,required this.addedOn});



Map<String,dynamic> toMap(Contact contact){
Map<String,dynamic> data = Map<String,dynamic>();
data["contact_id"]=contact.uid;
data["added_on"]=contact.addedOn;
return data;

}



Contact.fromMap(Map<String,dynamic> mapdata){
 
    this.uid=mapdata["contact_id"];
    this.addedOn=mapdata["added_on"];
  }


}