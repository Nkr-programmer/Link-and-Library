import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class Viewpdf extends StatefulWidget {
  @override
  _ViewpdfState createState() => _ViewpdfState();
}

class _ViewpdfState extends State<Viewpdf> {
  PDFDocument doc;
  @override
  Widget build(BuildContext context) {
    String data= ModalRoute.of(context).settings.arguments;
 Future   viewNow() async{
      doc=await PDFDocument.fromURL(data);
      setState(() {
        
      });
    }
    Widget Loading(){
      viewNow();
      if(doc==null){return Text("Loading...");}
    }
    return Scaffold(
      appBar:AppBar(      backgroundColor: Colors.red,
      title:Text("Retreive PDF"),),
body:doc==null?Loading():PDFViewer(document: doc),
    );
  }
}