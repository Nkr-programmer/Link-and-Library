import 'package:Chromser/Models/user.dart' as Users;
import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/chat_screen.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pickup/AllLibrary.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:Chromser/Screens/classifications/chat/widgets/custom_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

// ignore: camel_case_types
class Search_Screen extends StatefulWidget {
  int num;
  String text, work;
  Search_Screen(
      {Key? key, required this.num, required this.text, required this.work})
      : super(key: key);

  @override
  _Search_ScreenState createState() => _Search_ScreenState(num, text, work);
}

// ignore: camel_case_types
class _Search_ScreenState extends State<Search_Screen> {
  AuthMethods _authMethods = AuthMethods();
  List<Users.User> userList = List<Users.User>.empty(growable: true);
  Users.User? me = Users.User( uid: '',name:  "default",email: '',username: '',status: '',state: -1,profilePhoto: '',);
  String query = "";
  TextEditingController searchController = TextEditingController();
  FirebaseMethods _repository = FirebaseMethods();
  int num;
  String text, work;

  _Search_ScreenState(this.num, this.text, this.work);

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((User user) {
      me = Users.User(
          uid: user.uid,
          email: user.email ?? "default",
          name: user.displayName ?? "default",
          username: '',
          status: '',
          state: -1,
          profilePhoto: '');
      _authMethods.fetchAllUsers(user).then((List<Users.User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  GradientAppBar searchAppBar(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [
          UniversalVariables.gradientColorStart,
          UniversalVariables.gradientColorEnd
        ],
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {Navigator.pop(context);}),
      elevation: 0,
      bottom: PreferredSize(
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => searchController.clear());
                    //get rid of error so this is used
                  },
                ),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35,
                )),
          ),
        ),
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<Users.User> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((Users.User user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool matchedUserName = _getUsername.contains(_query);
                bool matchedName = _getName.contains(_query);
                return (matchedUserName || matchedName);
              }).toList()
            : [];

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context, index) {
          Users.User searchedUser = Users.User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username,
            email: suggestionList[index].email,
            status: '',
            state: -1,
          );

          return CustomTile(
            mini: false,
            onTap: () {
              if (work == "Search") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllLibrary(
                            num: num, receiver: searchedUser, sender: me)));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            receiver: searchedUser,
                            num: num,
                            text: text,
                            work: work)));
              }
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.profilePhoto),
              backgroundColor: Colors.grey,
            ),
            title: Text(searchedUser.username,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(searchedUser.name,
                style: TextStyle(
                  color: UniversalVariables.greyColor,
                )),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchAppBar(context),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: buildSuggestions(query)));
  }
}
