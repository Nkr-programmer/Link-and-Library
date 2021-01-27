import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/chat_screen.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/chat_screen_widgets/cached_image.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/Last_Message_container.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/online_dot_indicator.dart';
import 'package:Chromser/Screens/classifications/chat/models/contact.dart';
import 'package:Chromser/Screens/classifications/chat/provider/user_provider.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/chat_methods.dart';
import 'package:Chromser/Screens/classifications/chat/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// ignore: camel_case_types
class Contact_view extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods= AuthMethods();
  Contact_view(this.contact);

  @override
  Widget build(BuildContext context) {
  return FutureBuilder<User>(future:_authMethods.getUserDetailsbyId(contact.uid)
  ,builder: (context,snapshot){
    if(snapshot.hasData){
      User user = snapshot.data;
      return View_Layout(contact: user);
    }
     return Center(child: CircularProgressIndicator(),);
  },
  );
  }
// ignore: camel_case_types
}  class View_Layout extends StatelessWidget {
   final User contact;
final ChatMethods _chatMethods= ChatMethods();
  View_Layout({@required this.contact});
   
    @override
    Widget build(BuildContext context) {
      final UserProvider userProvider= Provider.of<UserProvider>(context);
      return Container(
    child:  CustomTile( mini: false,
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiver:contact))),
            title: Text(
              contact?.name??"..",
              style: TextStyle(
                  color: Colors.white, fontFamily: "Arial", fontSize: 19),
            ),
            subtitle: 
               LastMessageContainer(stream:
                  _chatMethods.fetchLastMessagesBetween(senderId: userProvider.getUser.uid,
                   receiverId: contact.uid),
                           
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                Cachedimage(contact.profilePhoto,isRound: true,radius:80),
                OnlineDotIndicator(uid: contact.uid)
                ],
              ),
            ),
          )
    );
    }
  }