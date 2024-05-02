import 'package:Chromser/Screens/classifications/chat/Screens/pickup/pickup_screen.dart';
import 'package:Chromser/Screens/classifications/chat/models/call.dart';
import 'package:Chromser/Screens/classifications/chat/provider/user_provider.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/call_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods= CallMethods();

   PickupLayout({required this.scaffold});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider= Provider.of<UserProvider>(context);
    return (userProvider!= null && userProvider.getUser!=null)?
    StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid:userProvider.getUser!.uid),
      builder:(context,snapshot){
        if(snapshot.hasData&&snapshot.data!.data()!=null){
         Call call= Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

if(!call.hasDialled){
  return Pickup_Screen(call: call);
}


  return scaffold;
        }
        return scaffold;
      },
    ):Scaffold(body:Center(
      child:CircularProgressIndicator(),
    ));
  }
}