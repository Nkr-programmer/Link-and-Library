import 'package:Chromser/Screens/classifications/chat/Screens/pageview/chatlistscreen.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pickup/pickup_layout.dart';
import 'package:Chromser/Screens/classifications/chat/enum/user_state.dart';
import 'package:Chromser/Screens/classifications/chat/provider/user_provider.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController? pageController;
  int _page = 0;
  final AuthMethods _authMethods = AuthMethods();
  UserProvider? userProvider;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider!.refreshUser();

      _authMethods.setUserState(
          userId: userProvider!.getUser!.uid, userState: UserState.OnliNE);
    });
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void didChangedAppLifeCycle(AppLifecycleState state) {
    String currentUserId = (userProvider != null && userProvider != null)
        ? userProvider!.getUser!.uid
        : "";
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.OnliNE)
            : print("resume");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("offline");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("Paused");

        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached");

        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController!.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 30;
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(child: ChatListScreen(num: 1)),
            Container(child: ChatListScreen(num: 2)),
            Container(child: ChatListScreen(num: 3)),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.people,size: _labelFontSize,
                        color: (_page == 0)
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                    label: "Private"
                    // title: Text(
                    //   "Private",
                    //   style: TextStyle(
                    //       fontSize: _labelFontSize,
                    //       color: (_page == 0)
                    //           ? UniversalVariables.lightBlueColor
                    //           : Colors.grey),
                    // ),
                    ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle,
                      color: (_page == 1)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  label: "Public",
                  // title: Text(
                  //   "Public",
                  //   style: TextStyle(
                  //       fontSize: _labelFontSize,
                  //       color: (_page == 1)
                  //           ? UniversalVariables.lightBlueColor
                  //           : Colors.grey),
                  // ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  label: "Individual",
                  // title: Text(
                  //   "Individual",
                  //   style: TextStyle(
                  //       fontSize: _labelFontSize,
                  //       color: (_page == 2)
                  //           ? UniversalVariables.lightBlueColor
                  //           : Colors.grey),
                  // ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
              activeColor: UniversalVariables.lightBlueColor,
              inactiveColor: Colors.grey,
              iconSize: _labelFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
