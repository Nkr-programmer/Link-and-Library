import 'package:Chromser/Models/recentlink.dart';
import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:Chromser/Screens/classifications/Services.dart';
import 'package:Chromser/Screens/classifications/Subconstants.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class Links extends StatefulWidget {
  final dynamic post;

  const Links({Key? key, this.post}) : super(key: key);
  @override
  _LinksState createState() => _LinksState(post);
}

class _LinksState extends State<Links> {
  FirebaseMethods _repository = FirebaseMethods();
  Future<void>? _launced;
  late String phoneNumber;
  // ignore: unused_field
  String _launchurl = 'https://console.firebase.google.com/';
  Future<void> launchinBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'could not resolve $url';
    }
  }

  Future<void> launchinApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'could not resolve $url';
    }
  }

  Future<void> launchuniversal(String url) async {
    if (await canLaunch(url)) {
      final bool nativeApp =
          await launch(url, forceSafariVC: false, universalLinksOnly: true);
      if (!nativeApp) {
        launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  Future<void> phoneCall(String url) async {
    if (await canLaunch(url))
      await launch(url);
    else {
      throw 'could not resolve $url';
    }
  }

  dynamic post;
  _LinksState(this.post);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            leading: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
          body: Container(
            child: FutureBuilder(
              future: Services.getSubs(context),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.length);
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Subconstants subconstants = snapshot.data[index];

                      Subconstants link;
                      RecentMessage _recentMessage;

                      uploadlink() {
                        if (subconstants.index == post["index"]) {
                          link = subconstants;

                          _recentMessage = RecentMessage(
                            index: link.index,
                            name: link.name,
                            brand: link.brand,
                            url: link.url,
                            image: link.image,
                            addedOn: Timestamp.now(),
                            number: 1,
                          );
                          _repository.addLinkToDb(_recentMessage);
                        }
                      }

                      void updateandcreate() {
                        _repository
                            .updateLinkToDb(subconstants)
                            .then((isNewUser) {
                          if (isNewUser) {
                            print("yes");
                          } else {
                            uploadlink();
                          }
                        });
                      }

                      return subconstants.index == post["index"]
                          ? Container(
                              height: 130,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  color: Colors.black54,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white.withAlpha(100),
                                        blurRadius: 10.0),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            subconstants.name,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            subconstants.brand,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        child: Image.network(
                                          subconstants.image,
                                          height: double.infinity,
                                        ),
                                        onLongPress: () {
                                          setState(() {
                                            updateandcreate();
                                            //  _launced=launchinBrowser(_launchurl);
                                            if (subconstants.index == 5) {
                                              _launced =
                                                  phoneCall(subconstants.url);
                                            } else if (subconstants.name ==
                                                "ORIGINAL") {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return HomeScreen();
                                              }));
                                            } else
                                              _launced = launchuniversal(
                                                  subconstants.url);

                                            // _launced=launchinApp(subconstants.url);
                                          });
                                          //Timer(const Duration(seconds:55),(){closeWebView();});
                                        },
                                      ),
                                    ),
                                    FutureBuilder(
                                        future: _launced,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<void> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error:${snapshot.error}');
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ],
                                ),
                              ))
                          : Container(color: Colors.blue);
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          )),
    );
  }
}
