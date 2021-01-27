import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/chat_screen.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/search_screen.dart';
import 'package:flutter/material.dart';

class Selection extends StatefulWidget {
  final String s;
  const Selection({Key key, this.s}) : super(key: key);

  @override
  _SelectionState createState() => _SelectionState(s);
}

class _SelectionState extends State<Selection> {
  String s;
  _SelectionState(this.s);
  int num, num3, num2;
  String query = "";
  TextEditingController searchController = TextEditingController();
  nameoflib(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: [Colors.lightGreenAccent, Colors.green],
        ),
      ),
      child: TextField(
        controller: searchController,
        onSubmitted: (val) {
          setState(() {
            query = val;
          });
        },
        cursorColor: Colors.black54,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 35,
        ),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => searchController.clear());
              },
            ),
            border: InputBorder.none,
            hintText: "   Name",
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 35,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: ListView(
            children: <Widget>[
              // alignment: Alignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              SizedBox(
                height: 80,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: num == 1 ? Colors.white30 : Colors.black87,
                              boxShadow: [
                                num == 1
                                    ? BoxShadow(
                                        color: Colors.white70.withAlpha(1000),
                                        blurRadius: 10.0)
                                    : BoxShadow(
                                        color: Colors.green.withAlpha(1000),
                                        blurRadius: 10.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(
                              "PRIVATE",
                              style: num == 1
                                  ? TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue.withBlue(100),
                                      fontWeight: FontWeight.bold),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          if (num == 1)
                            num = 0;
                          else {
                            num = 1;
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: num == 2 ? Colors.white30 : Colors.black87,
                              boxShadow: [
                                num == 2
                                    ? BoxShadow(
                                        color: Colors.white70.withAlpha(1000),
                                        blurRadius: 10.0)
                                    : BoxShadow(
                                        color: Colors.green.withAlpha(1000),
                                        blurRadius: 10.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(
                              "PUBLIC",
                              style: num == 2
                                  ? TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue.withBlue(100),
                                      fontWeight: FontWeight.bold),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          if (num == 2)
                            num = 0;
                          else {
                            num = 2;
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: num == 3 ? Colors.white30 : Colors.black87,
                              boxShadow: [
                                num == 3
                                    ? BoxShadow(
                                        color: Colors.white70.withAlpha(1000),
                                        blurRadius: 10.0)
                                    : BoxShadow(
                                        color: Colors.green.withAlpha(1000),
                                        blurRadius: 10.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(
                              "Individual",
                              style: num == 3
                                  ? TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue.withBlue(100),
                                      fontWeight: FontWeight.bold),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          if (num == 3)
                            num = 0;
                          else {
                            num = 3;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              nameoflib(context),
              SizedBox(height: 80),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color:
                                  num2 == 1 ? Colors.white30 : Colors.black87,
                              boxShadow: [
                                num2 == 1
                                    ? BoxShadow(
                                        color: Colors.white70.withAlpha(1000),
                                        blurRadius: 10.0)
                                    : BoxShadow(
                                        color: Colors.green.withAlpha(1000),
                                        blurRadius: 10.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(
                              "TEXT",
                              style: num2 == 1
                                  ? TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue.withBlue(100),
                                      fontWeight: FontWeight.bold),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          if (num2 == 1)
                            num2 = 0;
                          else {
                            num2 = 1;
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color:
                                  num2 == 2 ? Colors.white30 : Colors.black87,
                              boxShadow: [
                                num2 == 2
                                    ? BoxShadow(
                                        color: Colors.white70.withAlpha(1000),
                                        blurRadius: 10.0)
                                    : BoxShadow(
                                        color: Colors.green.withAlpha(1000),
                                        blurRadius: 10.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Text(
                              "IMAGES",
                              style: num2 == 2
                                  ? TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue.withBlue(100),
                                      fontWeight: FontWeight.bold),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          if (num2 == 2)
                            num2 = 0;
                          else {
                            num2 = 2;
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color:
                                  num2 == 3 ? Colors.white30 : Colors.black87,
                              boxShadow: [
                                num2 == 3
                                    ? BoxShadow(
                                        color: Colors.white70.withAlpha(1000),
                                        blurRadius: 10.0)
                                    : BoxShadow(
                                        color: Colors.green.withAlpha(1000),
                                        blurRadius: 10.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Text(
                              "BOOKS",
                              style: num2 == 3
                                  ? TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue.withBlue(100),
                                      fontWeight: FontWeight.bold),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          if (num2 == 3)
                            num2 = 0;
                          else {
                            num2 = 3;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 90),
              GestureDetector(
                child: Center(
                  child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: num3 == 1 ? Colors.white30 : Colors.black87,
                          boxShadow: [
                            num3 == 1
                                ? BoxShadow(
                                    color: Colors.white70.withAlpha(1000),
                                    blurRadius: 10.0)
                                : BoxShadow(
                                    color: Colors.green.withAlpha(1000),
                                    blurRadius: 10.0)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Text(
                          "CREATE =>",
                          style: num3 == 1
                              ? TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)
                              : TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue.withBlue(100),
                                  fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                onTap: () {
                  setState(() {
                    if (num3 == 1)
                      num3 = 0;
                    else {
                      num3 = 1;
                    }
                  });
                  if (num == 1) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return Search_Screen(
                            num: num, text: searchController.text, work: s);
                      },
                    ));
                  } else {
                    User a = User();
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatScreen(
                            receiver: a,//receiver is empty
                            num: num,
                            text: searchController.text,
                            work: s);
                      },
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
