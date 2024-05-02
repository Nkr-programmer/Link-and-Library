import 'package:Chromser/Models/user.dart' as Users;
import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/chat_screen.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/contact_view.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/quiet_box.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/selection.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/user_circle.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pickup/AllLibrary.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/search_screen.dart';
import 'package:Chromser/Screens/classifications/chat/models/contact.dart';
import 'package:Chromser/Screens/classifications/chat/models/libraryname.dart';
import 'package:Chromser/Screens/classifications/chat/provider/user_provider.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/chat_methods.dart';
import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:Chromser/Screens/classifications/chat/widgets/appbar.dart';
import 'package:Chromser/Screens/classifications/chat/widgets/custom_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  final int num;
  const ChatListScreen({Key? key, required this.num}) : super(key: key);
  @override
  _ChatListScreenState createState() => _ChatListScreenState(num);
}

class _ChatListScreenState extends State<ChatListScreen> {
  Users.User? me = Users.User( uid: '',name:  "default",email: '',username: '',status: '',state: -1,profilePhoto: '',);
  bool isNameNull = true;
  Users.User? receiver;
  List<Name>? names;
  Users.User? searchedUser = Users.User( uid: '',name:  "default",email: '',username: '',status: '',state: -1,profilePhoto: '',);
  int num;
  _ChatListScreenState(this.num);
  FirebaseMethods _repository = FirebaseMethods();
  Users.User? userd;
  Users.User? sender;
  AuthMethods _authMethods = new AuthMethods();
  void initState() {
    super.initState();
    isNameNull == true;
    _repository.getCurrentUser().then((User user) {
      userd = Users.User(
        uid: user.uid,
        name: user.displayName ?? "default",
        email: '',
        username: '',
        status: '',
        state: -1,
        profilePhoto: '',
      );
      sender = Users.User(
          uid: user.uid,
          email: user.email ?? "default",
          name: user.displayName ?? "default",
          username: '',
          status: '',
          state: -1,
          profilePhoto: '');
      if (num == 1) {
        _authMethods
            .fetchAllLibrariesPublic(sender, receiver, 2)
            .then((List<Name> list) {
          setState(() {
            names = list;
          });
        });
      } else if (num == 2) {
        _authMethods
            .fetchAllLibrariesPublic(sender, receiver, 1)
            .then((List<Name> list) {
          setState(() {
            names = list;
          });
        });
      } else if (num == 3) {
        _authMethods
            .fetchAllLibrariesPublic(sender, receiver, 3)
            .then((List<Name> list) {
          setState(() {
            names = list;
          });
        });
      }
    });
    isNameNull = false;
    print(names.toString()+"here is namesssssssssss");
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.question_mark,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Information'),
                content: const Text('1) Private is for personal Library of you and your friend\n2) Public is for Library shared to all users as brodcast\n3) Individual is for your own notes for Library'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return num < 3
                      ? Search_Screen(num: num, text: "", work: "Search")
                      : AllLibrary(
                          num: num, receiver: searchedUser, sender: me);
                },
              ));
            }),
        IconButton(
            icon: Icon(Icons.add_box, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Selection(s: "Add"),
                ),
              );
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(names!.length.toString()+" "+isNameNull.toString());
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      // floatingActionButton: NewChatButton(),
      body: names == null
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : names!.isEmpty
              ? QuietBox(num)
              : ChatListContainer(num, names!, sender!),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final int num;
  final List<Name> names;
  Users.User? sender;
  ChatListContainer(this.num, this.names, this.sender);
  @override
  _ChatListContainerState createState() =>
      _ChatListContainerState(num, names, sender!);
}

class _ChatListContainerState extends State<ChatListContainer> {
  final int num;
  final List<Name> names;
  Users.User? sender;
  _ChatListContainerState(this.num, this.names, this.sender);

  buildlibr(Users.User rece,List<Name> names,) {
    final List<Name> suggestionList = names != null ? names : [];
    AuthMethods _authMethods = new AuthMethods();
    Users.User? publicSenderUser;
    List<String> isthere = [];
    String have = "";
    int x = 1;
    isthere.add("abcdefghijkl");
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context, index) {
          Users.User searchedLib = Users.User(
              uid: rece.uid,
              profilePhoto: rece.profilePhoto,
              name: rece.name,
              username: rece.username,
              email: rece.email,
              status: '',
              state: -1);
          have = suggestionList[index].type.toString();
          if (isthere.contains(have)) {
            x = 0;
          } else {
            x = 1;
            isthere.add(suggestionList[index].type.toString());
          }
          print(x.toString()+" "+suggestionList[index].type.toString()+" "+searchedLib.uid);
          return x == 0
              ? Container()
              : CustomTile(
                  mini: false,
                  onTap: () {
                   if(num==2) _authMethods.getUserDetailsbyIdForchatlist(suggestionList[index].senderId).then((value) {
                      publicSenderUser=value;
                      print(x.toString()+" "+suggestionList[index].type.toString()+" "+publicSenderUser!.uid+" "+searchedLib.uid);
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatScreen(receiver:publicSenderUser ,num: 31, text: suggestionList[index].type,work: "Search")));
                     });
                  else{  Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ChatScreen(receiver: searchedLib,num:  num == 1
                                        ? 32
                                        : 3,
                                text: suggestionList[index].type,
                                work: "Search")));}
                  },
                  leading: CircleAvatar(
                    child: Text(suggestionList[index].type[0].toUpperCase()),
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(suggestionList[index].type,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                            suggestionList[index]
                                    .timestamp
                                    .toDate()
                                    .toString() +
                                "   " +
                                suggestionList[index]
                                    .timestamp
                                    .toDate()
                                    .year
                                    .toString(),
                            style: TextStyle(
                              color: UniversalVariables.greyColor,
                            )),
                        num == 1
                            ? Text("PRIVATE",
                                style: TextStyle(color: Colors.green))
                            : num == 2
                                ? Text("PUBLIC",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ))
                                : Text("INDIVIDUAL",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    )),
                      ],
                    ),
                  ),
                );
        }));
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: buildlibr(sender!, names),
// child:
//  StreamBuilder<QuerySnapshot>(
//    stream: names,
//    builder: (context, snapshot) {
//      if(snapshot.hasData){
//        var docList = snapshot.data.documents;

//       // if(docList.isEmpty){
//          return QuietBox(widget.num);
//       // }

//     //  return ListView.builder(padding:EdgeInsets.all(10),
//     //  itemCount: docList.length,
//     //  itemBuilder: (context,index){
//     //    Contact contact = Contact.fromMap(docList[index].data);
//     //    return Contact_view(contact);
//     //         },
//     //       );
//      }

// return Center(child: CircularProgressIndicator());

//    }
//  ),
    );
  }
}
