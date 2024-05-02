import 'package:Chromser/Models/user.dart' as Users;
import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/chat_screen.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/selection.dart';
import 'package:Chromser/Screens/classifications/chat/models/libraryname.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:Chromser/Screens/classifications/chat/widgets/custom_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllLibrary extends StatefulWidget {
  final Users.User? receiver, sender;
  final int num;

  const AllLibrary({ Key? key, required this.receiver, required this.sender, required this.num})
      : super(key: key);
  @override
  _AllLibraryState createState() => _AllLibraryState(receiver!, sender!, num);
}

class _AllLibraryState extends State<AllLibrary> {
  AuthMethods _authMethods = AuthMethods();
  List<Name> names =List<Name>.empty(growable: true);
  List<Name> names2 =List<Name>.empty(growable: true);
  List<Name> namesIndi =List<Name>.empty(growable: true);
  List<Users.User> userList =List<Users.User>.empty(growable: true);
  Users.User receiver, sender;
  int num;
  FirebaseMethods _repository = new FirebaseMethods();
  _AllLibraryState(this.receiver, this.sender, this.num);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (num == 3) {
      _repository.getCurrentUser().then((User user) {
        sender = Users.User(uid: user.uid, email: user.email ?? "default", name: user.displayName ?? "default", username: '', state: -1, status: '', profilePhoto: '');
        _authMethods
            .fetchAllLibrariesPublicforMineonly(sender, receiver)
            .then((List<Name> list) {
          setState(() {
            names = list;
          });
        });
        _authMethods
            .fetchAllLibrariesPublic(sender, receiver, 2)
            .then((List<Name> list) {
          setState(() {
            names2 = list;
          });
        });
 _authMethods
            .fetchAllLibrariesPublic(sender, receiver, 3)
            .then((List<Name> list) {
          setState(() {
            namesIndi = list;
          });
        });
    
      });
    } else if (num < 3)
      _authMethods
          .fetchAllLibraries(sender, receiver, num)
          .then((List<Name> list) {
        setState(() {
          names = list;
        });
      });
    else {}
  }

  buildlibr(Users.User rece, List<Name> names, List<Name> names2) {

    final List<Name> suggestionList = names != null ? names : [];
    final List<Name> suggestionList2 = names2 != null ? names2 : [];
   final List<Name> suggestionListIndi = namesIndi != null ? namesIndi : [];
 List<String> isthere=[];
 String have="";
 int x=1;
 isthere.add("abcdefghijkl");
    return suggestionList.length + suggestionList2.length+suggestionListIndi.length==0?Container(
    child: Row(
            children: <Widget>[
              Text("No folder Exist , Please create one",style: TextStyle(color: Colors.white),),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Selection(s:"Add"),
                  ),
                ),
              ),
            ]),
          )
    :ListView.builder(
        itemCount: suggestionList.length + suggestionList2.length+suggestionListIndi.length,
        itemBuilder: ((context, index) {
          Users.User searchedLib = Users.User(uid: rece.uid,profilePhoto: rece.profilePhoto,name: rece.name,username: rece.username,email: rece.email, status: '', state: -1);
               have=suggestionList.length > index?suggestionList[index].type.toString():
               (suggestionList2.length+suggestionList.length)>index?
               suggestionList2[index - suggestionList.length].type.toString():
               suggestionListIndi[index - (suggestionList2.length+suggestionList.length)].type.toString();
              if(isthere.contains(have)){x=0;}
              else{x=1;isthere.add(suggestionList.length > index?suggestionList[index].type.toString():
               (suggestionList2.length+suggestionList.length)>index?
               suggestionList2[index - suggestionList.length].type.toString():
               suggestionListIndi[index - (suggestionList2.length+suggestionList.length)].type.toString());}
          print(x);
          return  x==0?Container()
                :CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          receiver: searchedLib,
                          num: num == 3
                              ? suggestionList.length > index ? 31 : (suggestionList2.length+suggestionList.length)>index?32:3
                              : num,
                          text: suggestionList.length > index
                              ? suggestionList[index].type
                              : (suggestionList2.length+suggestionList.length)>index?
                               suggestionList2[index - suggestionList.length].type:
                               suggestionListIndi[index - (suggestionList2.length+suggestionList.length)].type,
                          work: "Search")));
            },
            leading: CircleAvatar(
              child: Text(suggestionList.length > index
                  ? suggestionList[index].type[0].toUpperCase()
                  : (suggestionList2.length+suggestionList.length)>index? suggestionList2[index - suggestionList.length].type[0].toUpperCase():
                               suggestionListIndi[index - (suggestionList2.length+suggestionList.length)].type[0].toUpperCase(),
              ),
              backgroundColor: Colors.grey,
            ),
            title: Text(
                suggestionList.length > index
                    ? suggestionList[index].type
                    :(suggestionList2.length+suggestionList.length)>index? suggestionList2[index - suggestionList.length].type:
                               suggestionListIndi[index -(suggestionList2.length+suggestionList.length)].type,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Container(
              child: Column(
                children: <Widget>[
                  Text(
                      suggestionList.length > index
                          ? suggestionList[index]
                                  .timestamp
                                  .toDate()
                                  .toString() +
                              "   " +
                              suggestionList[index]
                                  .timestamp
                                  .toDate()
                                  .year
                                  .toString()
                          :  (suggestionList2.length+suggestionList.length)>index?
                          suggestionList2[index - suggestionList.length]
                                  .timestamp
                                  .toDate()
                                  .toString() +
                              "   " +
                              suggestionList2[index - suggestionList.length]
                                  .timestamp
                                  .toDate()
                                  .year
                                  .toString(): 
                                  suggestionListIndi[index - (suggestionList2.length+suggestionList.length)]
                                  .timestamp
                                  .toDate()
                                  .toString() +
                              "   " +
                              suggestionListIndi[index - (suggestionList2.length+suggestionList.length)]
                                  .timestamp
                                  .toDate()
                                  .year
                                  .toString(),
                      style: TextStyle(
                        color: UniversalVariables.greyColor,
                      )),
                  num == 3
                      ? suggestionList.length > index
                          ? Text("PUBLIC",
                              style: TextStyle(
                                color: Colors.red,
                              ))
                          : (suggestionList2.length+suggestionList.length) > index?Text("PRIVATE",
                              style: TextStyle(color: Colors.green)):
                              Text("Individual",
                              style: TextStyle(
                                color: Colors.blue,
                              ))
                      : num == 1
                          ? Text("PRIVATE",
                              style: TextStyle(color: Colors.green))
                          : Text("PUBLIC",
                              style: TextStyle(
                                color: Colors.red,
                              )),
                ],
              ),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {Navigator.pop(context);}),
            actions: <Widget>[],
          ),
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: buildlibr(num == 3 ? sender : receiver, names, names2))),
    );
  }
}
