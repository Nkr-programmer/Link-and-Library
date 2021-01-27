import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(
        baseColor: UniversalVariables.blackColor,
        highlightColor: Colors.white,
        child:Text("N"),
       // child: Image.asset("assets/app_logo.png"),
        period: Duration(seconds: 1),
      ),
    );
  }
}