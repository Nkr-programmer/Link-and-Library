import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:Chromser/Models/user.dart' as Users;
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
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as Configs;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_screen_widgets/cached_image.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatScreen extends StatefulWidget {
  final Users.User? receiver;
  int num;
  String text, work;

  ChatScreen(
      {Key? key,
      required this.receiver,
      required this.num,
      required this.text,
      required this.work})
      : super(key: key);

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(receiver!, num, text, work);
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textfieldcontroller = TextEditingController();
  ChatMethods _chatMethods = ChatMethods();
  StorageMethods _storageMethods = StorageMethods();
  ScrollController _listScrollController = ScrollController();
  ImageUploadProvider? _imageUploadProvider;
  Users.User? sender;
  String _currentUserId = "hi";
  FocusNode textfieldFocus = FocusNode();
  bool isWriting = false;
  bool showemojipicker = false;
  FirebaseMethods _repository = FirebaseMethods();
  final Users.User receiver;
  int num;
  String text, work;
  AuthMethods _authMethods = AuthMethods();
  Future<void>? _launced;

  _ChatScreenState(this.receiver, this.num, this.text, this.work);
  Name? userList;
  Users.User? tempReceiver;
  String? specialIndividual;
  File? pdf;
  int mip = 0;
  // void selectpdf(String url) async{
  // pdf=await FilePicker.getFile();
  // print(pdf);
  // doc= await PDFDocument.fromURL(url);
  //  print(doc);
  // }

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    //  File selectfile = await FilePicker.getFile(type: FileType.custom);
    FilePickerResult? selectfile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Specify the allowed file extensions
    );
    List<int>? fileBytes;
    if (selectfile != null) {
      // Handle the picked file
      PlatformFile file = selectfile.files.first;
      // Read the bytes of the file
      fileBytes = file.bytes!;
    } else {
      // User canceled the picker
    }
    String fileName = '${randomName}.pdf';
    String id = "";
    String sid = "";
    if (work == "Add") {
      if (num == 1) {id = widget.receiver!.uid;}
      else if (num == 2) {id = "";}
    sid = sender!.uid;
    } 
    else {
      if (num == 1) {id = widget.receiver!.uid;} 
      else if (num == 2) {id = "";} 
      else if (num == 32) {id = specialIndividual!;} 
      else if (num == 31) {id = "";}
      if (num == 1) {sid = sender!.uid;} 
      else if (num == 2) {sid = widget.receiver!.uid;} 
      else if (num == 31) {sid = sender!.uid;} 
      else if (num == 32) {sid = sender!.uid;}
    }
    Message message = Message.pdfMessage(
        message: "PDF",
        receiverId: num == 3 ? sender!.uid : id,
        senderId: num == 3 ? sender!.uid : sid,
        photoUrl: "",
        timestamp: Timestamp.now(),
        type: 'pdf');
    if(fileBytes != null){
  print("gggggggggggggg");
    _storageMethods.uploadPdf(
        message: message,
        pdf: fileBytes,
        receiver: num < 3
            ? widget.receiver
            : num == 3
                ? sender
                : tempReceiver,
        sender: num == 2 ? widget.receiver : sender,
        num: num,
        text: text,
        imageUploadProvider: _imageUploadProvider,
        fileName: fileName,
        author:widget.receiver
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((User user) {
      _currentUserId = user.uid;
      setState(() {
        sender = Users.User(
            uid: user.uid,
            name: user.displayName ?? "default",
            profilePhoto: user.photoURL ?? "default",
            email: user.email ?? "default",
            username: '',
            status: '',
            state: 0);

        if (num == 32) {
          _authMethods
              .fetchLibrariesReceiver(_currentUserId, text)
              .then((Name? value) {
            setState(() {
              userList = value;
              if (userList!.senderId == sender!.uid) {
                specialIndividual = userList!.receiverId;
                tempReceiver = Users.User(
                    uid: specialIndividual ?? "default",
                    name: '',
                    email: '',
                    username: '',
                    status: '',
                    state: -1,
                    profilePhoto: '');
              } else {
                specialIndividual = userList!.senderId;
                tempReceiver = Users.User(
                    uid: specialIndividual ?? "default",
                    name: '',
                    email: '',
                    username: '',
                    status: '',
                    state: -1,
                    profilePhoto: '');
              }
            });
          });
        }
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
  Future<void> phoneCall(String url) async {
    if (await canLaunch(url))
      await launch(url);
    else {
      throw 'could not resolve $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return   userList == null && num == 32
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            ):
    Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider!.getViewState == ViewState.LOADING
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
    String id = "";
    String sid = "";
    if (work == "Add") {
      if (num == 1) {
        id = widget.receiver!.uid;
      } else if (num == 2) {
        id = "";
      }
      sid = sender!.uid;
    } else {
      if (num == 1) {
        id = widget.receiver!.uid;
      } else if (num == 2) {
        id = "";
      } else if (num == 32) {
        id = specialIndividual!;
      } else if (num == 31) {
        id = "";
      }

      if (num == 1) {
        sid = sender!.uid;
      } else if (num == 2) {
        sid = widget.receiver!.uid;
      } else if (num == 31) {
        sid = sender!.uid;
      } else if (num == 32) {
        sid = sender!.uid;
      }
    }
    Message _message = Message(
      receiverId: num == 3 ? sender!.uid : id,
      senderId: num == 3 ? sender!.uid : sid,
      message: texts,
      timestamp: Timestamp.now(),
      type: "text",
    );
    setState(() {
      isWriting = false;
    });
    textfieldcontroller.text = "";

    _chatMethods.addMessageToDb(_message,sender,num < 3? widget.receiver: num == 3? sender: tempReceiver,widget.text,widget.num,widget.receiver);
  } //num==2 because of sid conditions

  void pickImage({required ImageSource source}) async {
    // File selectedImage = await Utilities.pickImage(source: source);
    List<int>? fileBytes;
    String randomName = '${DateTime.now().millisecondsSinceEpoch}';
    print(source.name);
    if(source.name == "camera"){
        ImagePicker imagePicker = ImagePicker();
        XFile? selectedImage = await imagePicker.pickImage(source: source);
        print("Cameraaaaaaaaaa");
        if(selectedImage != null) {
          PlatformFile platformFile = PlatformFile(
            name: selectedImage.name,
            size: await selectedImage.length(),
            bytes: await selectedImage.readAsBytes(),
          );
          fileBytes=platformFile.bytes!;
        } else {// User canceled capturing the image
              }
    }
    else{
        print("galeryyyyyyyyyy");
        FilePickerResult? selectfile;
        selectfile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [    'jpg', 'jpeg', 'png', 'gif'], // Specify the allowed file extensions
        );
        if (selectfile != null) {
          // Handle the picked file
          PlatformFile file = selectfile.files.first;
          // Read the bytes of the file
          fileBytes = file.bytes!;
        } else {
          // User canceled the picker
                }
    }


    String fileName = '${randomName}.jpg';
    String id = "";
    String sid = "";
    if (work == "Add") {
      if (num == 1) {id = widget.receiver!.uid;}
      else if (num == 2) {id = "";}
    sid = sender!.uid;
    } else {
      if (num == 1) {id = widget.receiver!.uid;}
      else if (num == 2) {id = "";}
      else if (num == 32) {id = specialIndividual!;}
      else if (num == 31) {id = "";}
      if (num == 1) {sid = sender!.uid;}
      else if (num == 2) {sid = widget.receiver!.uid;}
      else if (num == 31) {sid = sender!.uid;}
      else if (num == 32) {sid = sender!.uid;}
    }
    Message message = Message.imageMessage(
        message: "IMAGE",
        receiverId: num == 3 ? sender!.uid : id,
        senderId: num == 3 ? sender!.uid : sid,
        photoUrl: "",
        timestamp: Timestamp.now(),
        type: 'image');
if(fileBytes != null){
    _storageMethods.uploadImage(
        message: message,
        image: fileBytes,
        receiver: num < 3
            ? widget.receiver
            : num == 3
                ? sender
                : tempReceiver,
        sender: num == 2 ? widget.receiver : sender,
        num: num,
        text: text,
        imageUploadProvider: _imageUploadProvider,
        fileName: fileName,
        author:widget.receiver
        );
}
        print("donnnnnnne");
  }


  CustomAppBar customAppBar(context) {
    return CustomAppBar(
        title: Column(
          children: <Widget>[
            Text("LIBRARY  " + text.toUpperCase()),
            if (work == "Add")
              Text("by  AUTHOR  " + sender!.email,
                  style: TextStyle(fontSize: 10, color: Colors.white70))
            else if (work == "Search")
              num == 1
                  ? Text("by  AUTHOR  " + receiver.email,
                      style: TextStyle(fontSize: 10, color: Colors.white70))
                  : num == 2
                      ? Text("by  AUTHOR  " + receiver.email,
                          style: TextStyle(fontSize: 10, color: Colors.white70))
                      : Text("by  AUTHOR  " + sender!.name,
                          style: TextStyle(fontSize: 10, color: Colors.white70))
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(from: sender, to: num < 3? widget.receiver: num == 3? sender: tempReceiver, context: context)
                    : {},
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              setState(() {
                _launced =phoneCall("tel:91");
              });
            },
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
    print(widget.receiver!.uid+" mmmmm "+text);
    return StreamBuilder(
      stream: work == "Add"
          ? num == 2
              ? FirebaseFirestore.instance
                  .collection("Public")
                  .doc(_currentUserId)
                  .collection(text)
                  .orderBy(TIMESTAMP_FIELD, descending: true)
                  .snapshots()
              : num == 3
                  ? FirebaseFirestore.instance
                      .collection("Individual")
                      .doc(_currentUserId)
                      .collection(text)
                      .orderBy(TIMESTAMP_FIELD, descending: true)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("Private")
                      .doc(_currentUserId)
                      .collection(widget.receiver!.uid)
                      .doc(text)
                      .collection(text)
                      .orderBy(TIMESTAMP_FIELD, descending: true)
                      .snapshots()
          : num == 2
              ? FirebaseFirestore.instance
                  .collection("Public")
                  .doc(receiver.uid)
                  .collection(text)
                  .orderBy(TIMESTAMP_FIELD, descending: true)
                  .snapshots()
              : num == 1
                  ? FirebaseFirestore.instance
                      .collection("Private")
                      .doc(_currentUserId)
                      .collection(widget.receiver!.uid)
                      .doc(text)
                      .collection(text)
                      .orderBy(TIMESTAMP_FIELD, descending: true)
                      .snapshots()
                  : num == 3
                      ? FirebaseFirestore.instance
                          .collection("Individual")
                          .doc(_currentUserId)
                          .collection(text)
                          .orderBy(TIMESTAMP_FIELD, descending: true)
                          .snapshots()
                      : num == 31
                          ? FirebaseFirestore.instance
                              .collection("Public")
                              .doc(widget.receiver!.uid)
                              .collection(text)
                              .orderBy(TIMESTAMP_FIELD, descending: true)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("Private")
                              .doc(_currentUserId)
                              .collection(specialIndividual!)
                              .doc(text)
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
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            controller: _listScrollController,
            itemBuilder: (context, index) {
              return chatMessageList(snapshot.data!.docs[index]);
            });
      },
    );
  }

  Widget chatMessageList(DocumentSnapshot snapshot) {
    print(snapshot.data().toString()+"ooooook");
    Message _message = Message.fromMap(snapshot.data() as Map<String, dynamic>);
    print("not ooooook");
    print(_message.message);
    return Container(
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
      child: getMessage(message),
    );
  }

  getMessage(Message message) {
    return message.type != MESSAGE_TYPE_IMAGE && message.type != "pdf"
        ? (mip == 0 || mip == 1)
            ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  message.message,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
            )
            : Container()//T
        : message.type == "pdf"
            ? message.photoUrl != null
                ? (mip == 0 || mip == 3)
                    ? Builder(
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              child: GestureDetector(
                                  onTap: () {
                                    String passData = message.photoUrl;
                                    print("goooooooot");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Viewpdf(passData: passData),
                                            ));
                                  },
                                  child:
                                      Container(child: Text(message.photoUrl)))),
                        ))
                    : Container()//B
                : Text("Url was null")
            : message.photoUrl != null
                ? (mip == 0 || mip == 2)
                    ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: (){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(message.message),
                              content: FullCachedimage(message.photoUrl,height: 500,width: 500,radius: 10,),
                              actions: <Widget>[],
                            ),
                          );
                        },
                        child: Cachedimage(
                            message.photoUrl,
                            height: 250,
                            width: 250,
                            radius: 10,
                          ),
                      ),
                    )
                    : Container()//I
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
      child: getMessage(message),
    );
  }

  Widget chatControls() {
    setwritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediamodal(context)  {
      showModalBottomSheet<void>(
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
                        TextButton(
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
                Expanded(
                    child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text("Media"),
                      subtitle: Text("Share Photoes and Video"),
                      leading: Icon(Icons.image),
                      onTap: () {pickImage(source: ImageSource.gallery);} ,
                    ),
                    ListTile(
                        title: Text("Books"),
                        subtitle: Text("Upload Books"),
                        leading: Icon(Icons.cloud_upload),
                        onTap: () => getPdfAndUpload()),
                    ListTile(
                      title: Text("Messages"),
                      subtitle: Text("Show Messages"),
                      leading: Icon(Icons.message),
                      onTap: () {
                        setState(() {
                          mip != 1 ? mip = 1 : mip = 0;
                        });
                      },
                    ),
                    ListTile(
                      title: Text("Images"),
                      subtitle: Text("Show Images"),
                      leading: Icon(Icons.image),
                      onTap: () {
                        setState(() {
                          mip != 2 ? mip = 2 : mip = 0;
                        });
                      },
                    ),
                    ListTile(
                      title: Text("Files"),
                      subtitle: Text("Show  Files"),
                      leading: Icon(Icons.book),
                      onTap: () {
                        setState(() {
                          mip != 3 ? mip = 3 : mip = 0;
                        });
                      },
                    ),
                    ListTile(
                      title: Text("ALL"),
                      subtitle: Text("All files,images,messages"),
                      leading: Icon(Icons.image),
                      onTap: () {
                        setState(() {
                          mip = 0;
                        });
                      },
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
              onTap: () {
                setState(() {
                  print("yooo baby");
               addMediamodal(context);   
               print("yooo baby1"+context.size.toString());
                });
              },
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
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: TextField(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top:4.0,right:10),
                  child: IconButton(
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
                      icon: Icon(Icons.face)),
                )
              ],
            )),
            isWriting
                ? Container()
                : GestureDetector(
                    onTap: () => pickImage(source: ImageSource.camera),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.camera_alt),
                    )),
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
    return Configs.EmojiPicker(
      onEmojiSelected: (category, emoji) {
        setState(
          () {
            textfieldcontroller.text = textfieldcontroller.text + emoji.emoji;
          },
        );
      },
      onBackspacePressed: () {
        // Do something when the user taps the backspace button (optional)
        // Set it to null to hide the Backspace-Button
      },
      textEditingController:
          textfieldcontroller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
      config: Configs.Config(
        height: 256,
        checkPlatformCompatibility: true,
        emojiViewConfig: Configs.EmojiViewConfig(
          // Issue: https://github.com/flutter/flutter/issues/28894
          backgroundColor: UniversalVariables.separatorColor,
          columns: 7,
          emojiSizeMax: 28 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.20
                  : 1.0),
        ),
        swapCategoryAndBottomBar: false,
        skinToneConfig:
            const Configs.SkinToneConfig(indicatorColor: Color(0xff2b9ed4)),
        categoryViewConfig:
            const Configs.CategoryViewConfig(indicatorColor: Color(0xff2b9ed4)),
        bottomActionBarConfig: const Configs.BottomActionBarConfig(),
        searchViewConfig: const Configs.SearchViewConfig(),
      ),
    );
    // return EmojiPicker(
    //   indicatorColor: UniversalVariables.blueColor,
    //   rows: 3,
    //   recommendKeywords: ["face", "sad", "happy", "party"],
    //   numRecommended: 50,
    // );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomTile(
          mini: false,
          onTap: onTap(),
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
