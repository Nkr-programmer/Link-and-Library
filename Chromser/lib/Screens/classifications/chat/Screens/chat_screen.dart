import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:Chromser/Models/user.dart';
import 'package:Chromser/Repositeries/firebase_methods.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/pickup/Viewpdf.dart';
import 'package:Chromser/Screens/classifications/chat/constants/strings.dart';
import 'package:Chromser/Screens/classifications/chat/enum/view_state.dart';
import 'package:Chromser/Screens/classifications/chat/models/libraryname.dart';
import 'package:Chromser/Screens/classifications/chat/models/message.dart';
import 'package:Chromser/Screens/classifications/chat/provider/Image_uploader.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Auth_methods.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/Storage_methods.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/chat_methods.dart';
import 'package:Chromser/Screens/classifications/chat/utils/call_utilites.dart';
import 'package:Chromser/Screens/classifications/chat/utils/permission.dart';
import 'package:Chromser/Screens/classifications/chat/utils/universal_variables.dart';
import 'package:Chromser/Screens/classifications/chat/utils/utilities.dart';
import 'package:Chromser/Screens/classifications/chat/widgets/appbar.dart';
import 'package:Chromser/Screens/classifications/chat/widgets/custom_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'chat_screen_widgets/cached_image.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  int num;
  String text, work;

  ChatScreen({Key key, this.receiver, this.num, this.text, this.work})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(receiver, num, text, work);
}

class _ChatScreenState extends State<ChatScreen> {
  
  TextEditingController textfieldcontroller = TextEditingController();
  ChatMethods _chatMethods = ChatMethods();
  StorageMethods _storageMethods = StorageMethods();
  ScrollController _listScrollController = ScrollController();
  ImageUploadProvider _imageUploadProvider;
  User sender;
  String _currentUserId = "hi";
  FocusNode textfieldFocus = FocusNode();
  bool isWriting = false;
  bool showemojipicker = false;
  FirebaseMethods _repository = FirebaseMethods();
  final User receiver;
  int num;
  String text, work;
  AuthMethods _authMethods = AuthMethods();
 

  _ChatScreenState(this.receiver, this.num, this.text, this.work);
  Name userList;
  User tempReceiver;
  String specialIndividual;
  File pdf;
  PDFDocument doc;
  int mip=0;
  // void selectpdf(String url) async{
  // pdf=await FilePicker.getFile();
  // print(pdf);
  // doc= await PDFDocument.fromURL(url);
  //  print(doc);
  // }

Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName="";
    for(var i=0;i<20;i++)
    {
      print(rng.nextInt(100));
  randomName +=rng.nextInt(100).toString();
    }
     File selectfile = await FilePicker.getFile(type: FileType.custom);
       String fileName = '${randomName}.pdf';
    String id;
    String sid;
    if (work == "Add") {
      if (num == 1) {
        id = widget.receiver.uid;
      } else if (num == 2) {
        id = "";
      }
      sid = sender.uid;
    }else {
      if (num == 1) {
        id = widget.receiver.uid;
      } else if (num == 2) {
        id = "";
      } else if (num == 32) {
        id = specialIndividual;
      } else if (num == 31) {
        id = "";
      }

      if (num == 1) {
        sid = sender.uid;
      } else if (num == 2) {
        sid = widget.receiver.uid;
      } else if (num == 31) {
        sid = sender.uid;
      } else if (num == 32) {
        sid = sender.uid;
      }
    }
     

        Message message = Message.pdfMessage(
        message: "PDF",
      receiverId: num == 3 ? sender.uid : id,
      senderId: num == 3 ? sender.uid : sid,
        photoUrl: "",
        timestamp: Timestamp.now(),
        type: 'pdf');
        
    _storageMethods.uploadPdf(
        message:message,
        pdf: selectfile.readAsBytesSync(),
        receiver: num < 3 ? widget.receiver : num == 3 ? sender : tempReceiver,
        sender: num == 2 ? widget.receiver : sender,
        num: num,
        text: text,
        imageUploadProvider: _imageUploadProvider,
        fileName:fileName);
  }



  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser user) {
      _currentUserId = user.uid;
      setState(() {
        sender = User(
            uid: user.uid,
            name: user.displayName,
            profilePhoto: user.photoUrl,
            email: user.email);

        if (num == 32)
          _authMethods
              .fetchLibrariesReceiver(_currentUserId, text)
              .then((Name value) {
            setState(() {
              userList = value;
              if (userList.senderId == sender.uid) {
                specialIndividual = userList.receiverId;
                tempReceiver = User(uid: specialIndividual);
              } else {
                specialIndividual = userList.senderId;
                tempReceiver = User(uid: specialIndividual);
              }
            });
          });
      });
    });
  }

  showKeyboards() => textfieldFocus.requestFocus();
  hideKeyboard() => textfieldFocus.unfocus();
  hideEmojiCoontainer() {
    setState(() {
      showemojipicker = false;
    });
  }

  showEmojiCoontainer() {
    setState(() {
      showemojipicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child:
                  messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator())
                : Container(),
            chatControls(),
            showemojipicker ? Container(child: emojiContainer()) : Container(),
          ],
        ));
  }

  sendmessage() {
    var texts = textfieldcontroller.text;
    String id;
    String sid;
    if (work == "Add") {
      if (num == 1) {
        id = widget.receiver.uid;
      } else if (num == 2) {
        id = "";
      }
      sid = sender.uid;
    } else {
      if (num == 1) {
        id = widget.receiver.uid;
      } else if (num == 2) {
        id = "";
      } else if (num == 32) {
        id = specialIndividual;
      } else if (num == 31) {
        id = "";
      }

      if (num == 1) {
        sid = sender.uid;
      } else if (num == 2) {
        sid = widget.receiver.uid;
      } else if (num == 31) {
        sid = sender.uid;
      } else if (num == 32) {
        sid = sender.uid;
      }
    }
    Message _message = Message(
      receiverId: num == 3 ? sender.uid : id,
      senderId: num == 3 ? sender.uid : sid,
      message: texts,
      timestamp: Timestamp.now(),
      type: "text",
    );
    setState(() {
      isWriting = false;
    });
    textfieldcontroller.text = "";

    _chatMethods.addMessageToDb(
        _message,
        num == 2 ? widget.receiver : sender,
        num < 3 ? widget.receiver : num == 3 ? sender : tempReceiver,
        widget.text,
        widget.num);
  } //num==2 because of sid conditions

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utilities.pickImage(source: source);

    String id;
    String sid;
    if (work == "Add") {
      if (num == 1) {
        id = widget.receiver.uid;
      } else if (num == 2) {
        id = "";
      }
      sid = sender.uid;
    }else {
      if (num == 1) {
        id = widget.receiver.uid;
      } else if (num == 2) {
        id = "";
      } else if (num == 32) {
        id = specialIndividual;
      } else if (num == 31) {
        id = "";
      }

      if (num == 1) {
        sid = sender.uid;
      } else if (num == 2) {
        sid = widget.receiver.uid;
      } else if (num == 31) {
        sid = sender.uid;
      } else if (num == 32) {
        sid = sender.uid;
      }
    }
     

        Message message = Message.imageMessage(
        message: "IMAGE",
      receiverId: num == 3 ? sender.uid : id,
      senderId: num == 3 ? sender.uid : sid,
        photoUrl: "",
        timestamp: Timestamp.now(),
        type: 'image');
        
    _storageMethods.uploadImage(
        message:message,
        image: selectedImage,
        receiver: num < 3 ? widget.receiver : num == 3 ? sender : tempReceiver,
        sender: num == 2 ? widget.receiver : sender,
        num: num,
        text: text,
        imageUploadProvider: _imageUploadProvider);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
        title: Column(
          children: <Widget>[
            Text("LIBRARY  " + text.toUpperCase()),
            if (work == "Add")
              Text("by  AUTHOR  " + sender.email,
                  style: TextStyle(fontSize: 10, color: Colors.white70))
            else if (work == "Search")
              num == 1
                  ? Text("by  AUTHOR  " + receiver.email,
                      style: TextStyle(fontSize: 10, color: Colors.white70))
                  : num == 2
                      ? Text("by  AUTHOR  " + receiver.email,
                          style: TextStyle(fontSize: 10, color: Colors.white70))
                      : Text("by  AUTHOR  " + sender.name,
                          style: TextStyle(fontSize: 10, color: Colors.white70))
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                        from: sender, to: widget.receiver, context: context)
                    : {},
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {},
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false);
  }

  Widget messageList() {
    return StreamBuilder(
      stream: work == "Add"
          ? num == 2
              ? Firestore.instance
                  .collection("Public")
                  .document(_currentUserId)
                  .collection(text)
                  .orderBy(TIMESTAMP_FIELD, descending: true)
                  .snapshots()
              : num == 3
                  ? Firestore.instance
                      .collection("Individual")
                      .document(_currentUserId)
                      .collection(text)
                      .orderBy(TIMESTAMP_FIELD, descending: true)
                      .snapshots()
                  : Firestore.instance
                      .collection("Private")
                      .document(_currentUserId)
                      .collection(widget.receiver.uid)
                      .document(text)
                      .collection(text)
                      .orderBy(TIMESTAMP_FIELD, descending: true)
                      .snapshots()
          : num == 2
              ? Firestore.instance
                  .collection("Public")
                  .document(receiver.uid)
                  .collection(text)
                  .orderBy(TIMESTAMP_FIELD, descending: true)
                  .snapshots()
              : num == 1
                  ? Firestore.instance
                      .collection("Private")
                      .document(_currentUserId)
                      .collection(widget.receiver.uid)
                      .document(text)
                      .collection(text)
                      .orderBy(TIMESTAMP_FIELD, descending: true)
                      .snapshots()
                  : num == 3
                      ? Firestore.instance
                          .collection("Individual")
                          .document(_currentUserId)
                          .collection(text)
                          .orderBy(TIMESTAMP_FIELD, descending: true)
                          .snapshots()
                      : num == 31
                          ? Firestore.instance
                              .collection("Public")
                              .document(receiver.uid)
                              .collection(text)
                              .orderBy(TIMESTAMP_FIELD, descending: true)
                              .snapshots()
                          : Firestore.instance
                              .collection("Private")
                              .document(_currentUserId)
                              .collection(specialIndividual)
                              .document(text)
                              .collection(text)
                              .orderBy(TIMESTAMP_FIELD, descending: true)
                              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );

          // ignore: dead_code
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _listScrollController.animateTo(
                _listScrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut);
          });
        }

        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: _listScrollController,
            itemBuilder: (context, index) {
            
              return 
                  chatMessageList(snapshot.data.documents[index]);
            
             
            });
      },
    );
  }

  Widget chatMessageList(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    print(_message.message);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Container(
            alignment: _message.senderId == _currentUserId
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: _message.senderId == _currentUserId
                ? senderLayout(_message)
                : recieverLayout(_message)));
  }

  Widget senderLayout(Message message) {
    Radius messagRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
          color: UniversalVariables.senderColor,
          borderRadius: BorderRadius.only(
              bottomLeft: messagRadius,
              topLeft: messagRadius,
              topRight: messagRadius)),
      child: Padding(padding: EdgeInsets.all(10), child: getMessage(message)),
    );
  }

  getMessage(Message message) {
  
    return message.type != MESSAGE_TYPE_IMAGE&&message.type!="pdf"
        ? (mip==0||mip==1)?Text(
            message.message,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ):Text("T")
        :message.type=="pdf"?
        message.photoUrl != null
            ?
         (mip==0||mip==3)?  Builder(builder: (context) => 
             Container(child:GestureDetector(onTap:(){
               String passData= message.photoUrl;
               Navigator.push(context,MaterialPageRoute(builder: (context)=>Viewpdf(),settings:RouteSettings(arguments: passData)));
             },child: Container(child:Text(message.photoUrl)))
             ) ):Text("B")
            : Text("Url was null")
         :message.photoUrl != null
            ?   (mip==0||mip==2)?Cachedimage(
                message.photoUrl,
                height: 250,
                width: 250,
                radius: 10,
              ):Text("I")
            : Text("Url was null");
  }

  Widget recieverLayout(Message message) {
    Radius messagRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
          color: UniversalVariables.senderColor,
          borderRadius: BorderRadius.only(
              bottomLeft: messagRadius,
              topRight: messagRadius,
              bottomRight: messagRadius)),
      child: Padding(padding: EdgeInsets.all(10), child: getMessage(message)),
    );
  }

  Widget chatControls() {
    setwritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediamodal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.maybePop(context),
                            child: Icon(Icons.close)),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Content and Tools",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )))
                      ],
                    )),
                Flexible(
                    child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Media",
                      subtitle: "Share Photoes and Video",
                      icon: Icons.image,
                      onTap: () => pickImage(source: ImageSource.gallery),
                    ),
                    ModalTile(
                      title: "Books",
                      subtitle: "Upload Books",
                      icon: Icons.cloud_upload,
                      onTap: () => getPdfAndUpload()
                    ),
                    ModalTile(
                      title: "Messages",
                      subtitle: "Show Messages",
                      icon: Icons.message,
                      onTap: (){setState(() {
                        mip!=1?mip=1:mip=0;
                      });},
                    ),
                    ModalTile(
                      title: "Images",
                      subtitle: "Show Images",
                      icon: Icons.image,
                       onTap: (){setState(() {
                        mip!=2?mip=2:mip=0;
                      });},
                    ),
                    ModalTile(
                      title: "Files",
                      subtitle: "Show  Files",
                      icon: Icons.book,
                       onTap: (){setState(() {
                        mip!=3?mip=3:mip=0;
                      });},
                    ),
                    ModalTile(
                      title: "ALL",
                      subtitle: "All files,images,messages",
                      icon: Icons.image,
                      onTap: (){setState(() {
                      mip=0;
                      });},
                    ),
                  ],
                ))
              ],
            );
          });
    }

    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => addMediamodal(context),
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: Icon(Icons.add)),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Stack(
              children: [
                TextField(
                  controller: textfieldcontroller,
                  focusNode: textfieldFocus,
                  onTap: () => hideEmojiCoontainer(),
                  style: TextStyle(color: Colors.white),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setwritingTo(true)
                        : setwritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(color: UniversalVariables.greyColor),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(const Radius.circular(60.0)),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                IconButton(
                    splashColor: Colors.teal,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (!showemojipicker) {
                        hideKeyboard();
                        showEmojiCoontainer();
                      } else {
                        showKeyboards();
                        hideEmojiCoontainer();
                      }
                    },
                    icon: Icon(Icons.face))
              ],
            )),
            isWriting
                ? Container()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.record_voice_over),
                  ),
            isWriting
                ? Container()
                : GestureDetector(
                    onTap: () => pickImage(source: ImageSource.camera),
                    child: Icon(Icons.camera_alt)),
            isWriting
                ? Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        gradient: UniversalVariables.fabGradient,
                        shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 18,
                      ),
                      onPressed: () => sendmessage(),
                    ))
                : Container()
          ],
        ));
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(
          () {
            textfieldcontroller.text = textfieldcontroller.text + emoji.emoji;
          },
        );
      },
      recommendKeywords: ["face", "sad", "happy", "party"],
      numRecommended: 50,
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile(
      {@required this.title,
      @required this.subtitle,
      @required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomTile(
          mini: false,
          onTap: onTap,
          leading: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: UniversalVariables.receiverColor,
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                icon,
                color: UniversalVariables.greyColor,
                size: 38,
              )),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: UniversalVariables.greyColor, fontSize: 14),
          ),
          title: Text(
            title,
            style: TextStyle(color: UniversalVariables.greyColor, fontSize: 18),
          )),
    );
  }
}
