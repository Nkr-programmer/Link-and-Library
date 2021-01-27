import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius:BorderRadius.circular(50)
      ),
      child:Icon(Icons.edit,color:Colors.white,
      size:25),
      padding: EdgeInsets.all(15),
    );
  }
}