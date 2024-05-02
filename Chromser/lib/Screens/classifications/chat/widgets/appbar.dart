import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar(
      {Key? key,
      required this.title,
      required this.actions,
      required this.leading,
      required this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: UniversalVariables.blackColor,
          border: Border(
              bottom: BorderSide(
            color: UniversalVariables.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ))),
      child: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        elevation: 0,
        actions: actions,
        leading: leading,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
