import 'package:Chromser/Models/recentlink.dart';
import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:Chromser/Screens/classifications/Subconstants.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/home_screen.dart';
import 'package:Chromser/Screens/classifications/links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:snappable/snappable.dart';
import 'package:url_launcher/url_launcher.dart';
class NewOrMost extends StatefulWidget {
   final String name;

  const NewOrMost({Key key,  this.name}) : super(key: key);
  @override
  _NewOrMostState createState() => _NewOrMostState(name);
}

class _NewOrMostState extends State<NewOrMost> {
   String name;
  _NewOrMostState(this.name);
   FirebaseMethods _repository = FirebaseMethods();
  
  List<RecentMessage> linksSets ;
 static final cont = GlobalKey<SnappableState>();
 Subconstants subconstants ;
Subconstants link;
RecentMessage _recentMessage;
 uploadlink(){
{link=subconstants;

 _recentMessage =RecentMessage(
          index: link.index,
          name:  link.name,
          brand: link.brand,
          url:   link.url,
          image: link.image,
          addedOn: Timestamp.now(),
          number: 1,
       
        );
_repository.addLinkToDb(_recentMessage);}
}
void updateandcreate(){
   _repository.updateLinkToDb(subconstants).then((isNewUser) {
  if(isNewUser){print("yes");}
  else{uploadlink();}
});
}   
 Future<void> launchuniversal(String url)async{
if(await canLaunch(url)){
  final bool nativeApp =await launch(url,forceSafariVC: false,universalLinksOnly: true );
  if(!nativeApp){
    launch(url,forceSafariVC: true,);
  }
}

}
  Future<void> phoneCall(String url)async{
if(await canLaunch(url))
await launch(url);
   else{
     throw'could not resolve $url';
   }
  }
   @override
   
  void initState() {
    super.initState();
     _repository.fetchAllLinks().then((List<RecentMessage> list){
setState((){
  linksSets= list;
  if(name=="Newest")
          {print("yes");}
          else
          { linksSets.sort((a,b)=>a.number.compareTo(b.number));}
          print(linksSets.elementAt(0).name);
           print(linksSets.elementAt(1).name);
});
      
    
    });
  }
  @override
  Widget build(BuildContext context) {
//   void snaps() { setState(() {
    
//   });
// cont.currentState.snap();
// }
    Widget clock(List<RecentMessage>suggestionList,int index){
      return Slidable(
       actions: <Widget>[
    IconSlideAction(
      caption: 'Archive',
      color: Colors.blue,
      icon: Icons.archive,
      onTap: () => Scaffold.of(context).showSnackBar(new SnackBar(content:Text("Archive"))),
    ),
    IconSlideAction(
      caption: 'Share',
      color: Colors.indigo,
      icon: Icons.share,
      onTap: () => Scaffold.of(context).showSnackBar(new SnackBar(content:Text("Share"))),
    ),
  ],
  secondaryActions: <Widget>[
    IconSlideAction(
      caption: 'More',
      color: Colors.black45,
      icon: Icons.more_horiz,
      onTap: () => Scaffold.of(context).showSnackBar(new SnackBar(content:Text("More"))),
    ),
    IconSlideAction(
      caption: 'Delete',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () { setState(() { 
        _repository.deleteLinkToDb(linksSets.elementAt(index));
       linksSets.removeAt(index);       
      });
      }),
  ],
  actionPane: SlidableDrawerActionPane(),
  actionExtentRatio: 0.25,
      child: Container(
      
      child: Container(
                  height: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                  color: Colors.black54, boxShadow: [
                    BoxShadow(color: Colors.white.withAlpha(100), blurRadius: 10.0),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                suggestionList[index].name,
                                style: const TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                suggestionList[index].brand,
                                style: const TextStyle(fontSize: 17, color: Colors.grey),
                              ),
                              
                            ],
                          ),
                        ),
                        Expanded(
                                          child: GestureDetector(
                                      child: Image.network( suggestionList[index].image,
                              height: double.infinity,
                             
                            ),
                          onLongPress: (){ 
            setState(() {
              subconstants=Subconstants(      index: suggestionList[index].index,
          name:  suggestionList[index].name,
          brand: suggestionList[index].brand,
          url:   suggestionList[index].url,
          image: suggestionList[index].image,
          );
            });updateandcreate();
              if(suggestionList[index].index==5){   phoneCall(suggestionList[index].url);}
              else
              if(suggestionList[index].name=="ORIGINAL"){ Navigator.push(context, MaterialPageRoute(builder: (context){return HomeScreen();}));}
              else
                 launchuniversal(suggestionList[index].url);

           },),
                        ),
                        
                      ],
                    ),
                  )),
    ),
  
 
          );}
    final List<RecentMessage> suggestionList = linksSets!=null?linksSets.toList():[];
    return SafeArea(
          child: Scaffold(
         backgroundColor: Colors.black, appBar: AppBar(
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
    
    body:Container(
  child:
    ListView.builder(itemCount:suggestionList.length,reverse:true,itemBuilder: (BuildContext context,int index){
      
          return Snappable(
    //key:cont,
    child:clock(suggestionList, index));
  }))
));
  }
}