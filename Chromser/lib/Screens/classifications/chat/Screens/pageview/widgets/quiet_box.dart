//1
import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Repositeries/addLibrary.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pageview/widgets/selection.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pickup/AllLibrary.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/search_screen.dart';
import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:flutter/material.dart';


class QuietBox extends StatelessWidget {
  int num;
  QuietBox(this.num);
User me=User();
User searchedUser=User();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Start searching libraries",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.lightBlueColor,
                child: Text("START SEARCHING"),
                onPressed: () =>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
 return num<3?Search_Screen(num:num,text: "",work:"Search"):AllLibrary(num:num,receiver:searchedUser,sender:me);
  },)),
              ),
              Text(
                "Start adding libraries",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.lightBlueColor,
                child: Text("START ADDING"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Selection(s:"Add"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}