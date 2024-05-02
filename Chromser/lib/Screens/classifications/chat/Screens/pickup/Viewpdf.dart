import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Viewpdf extends StatefulWidget {
  String passData;
  Viewpdf({Key? key,required this.passData}): super(key: key);
  @override
  _ViewpdfState createState() => _ViewpdfState(passData);
}

class _ViewpdfState extends State<Viewpdf> {
    bool running=false;
    Future<void>? _launced;
    String passData="";
    
      _ViewpdfState( this.passData);
    Future<void> launchinApp(String? url) async {
    if (await canLaunch(url!)) {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _launced=launchuniversal(passData);
    running=true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(      backgroundColor: Colors.red,
      title:Text("Retreive PDF"),),
body:running==false?CircularProgressIndicator():launchuniversal(passData) as Widget,
    );
  }
}