import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Chromser/Screens/classifications/chat/const/agora_config.dart';
import 'package:Chromser/Screens/classifications/chat/models/call.dart';
import 'package:Chromser/Screens/classifications/chat/provider/user_provider.dart';
import 'package:Chromser/Screens/classifications/chat/resourses/call_methods.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

const appId = APP_ID;
// const token = "<-- Insert Token -->";
class CallScreen extends StatefulWidget {
  final Call call;
   CallScreen({ required this.call}) ;
  @override
  _CallScreenState createState() => _CallScreenState();
}


class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();

  UserProvider? userProvider;
  StreamSubscription? callStreamSubscription;

  static final _users = <int>[];
  // bool muted = false;
  // late RtcEngine _engine;

  int? _remoteUid;
  bool _localUserJoined = false;
  RtcEngine? _engine;
  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initAgora();
  }
  Future<void>  addPostFrameCallback() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods
          .callStream(uid: userProvider!.getUser!.uid)
          .listen((DocumentSnapshot ds) {
        // defining the logic
        switch (ds.data()) {
          case null:
            // snapshot is null which means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }
  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
String tokens='';
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          tokens=token;
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableVideo();
    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: tokens,
      channelId: widget.call.channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
    callMethods.endCall(
    call: widget.call,);
    });
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine!.leaveChannel();
    await _engine!.release();
    callStreamSubscription!.cancel();

  }
    // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection:  RtcConnection(channelId: widget.call.channelId),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
  // @override
  // void initState() {
  //   super.initState();
  //   addPostFrameCallback();
  //   initializeAgora();
  // }



  /// Toolbar layout
  // Widget _toolbar() {
  //   return Container(
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         RawMaterialButton(
  //           onPressed: _onToggleMute,
  //           child: Icon(
  //             muted ? Icons.mic : Icons.mic_off,
  //             color: muted ? Colors.white : Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: muted ? Colors.blueAccent : Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () => callMethods.endCall(
  //             call: widget.call,
  //           ),
  //           child: Icon(
  //             Icons.call_end,
  //             color: Colors.white,
  //             size: 35.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.redAccent,
  //           padding: const EdgeInsets.all(15.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: _onSwitchCamera,
  //           child: Icon(
  //             Icons.switch_camera,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         )
  //       ],
  //     ),
  //   );
  // }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }
// }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: SizedBox(
          //     width: 100,
          //     height: 150,
          //     child: Center(
          //       child: _localUserJoined
          //           ? AgoraVideoView(
          //               controller: VideoViewController(
          //                 rtcEngine: _engine!,
          //                 canvas: const VideoCanvas(uid: 0,cropArea: Rectangle(x:60,y:60,width: 100,height: 150)),
          //               ),
          //             )
          //           : const CircularProgressIndicator(),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: 
            RawMaterialButton(
              onPressed: () =>callMethods.endCall(call:widget.call),
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
            ),
          )
        ],
      ),
    );
  }
}
// class _CallScreenState extends State<CallScreen> {
//   final CallMethods callMethods=CallMethods();

//   UserProvider userProvider;
//   StreamSubscription callStreamSubscriptions;
//    static final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   @override
//   void initstate(){
// super.initState;
// addPostFrameCallback();
//  initializeAgora();
//   }
//    Future<void> initializeAgora() async {
//     if (APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }

//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await AgoraRtcEngine.enableWebSdkInteroperability(true);
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     configuration.dimensions = Size(1920, 1080);
//     await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
//     await AgoraRtcEngine.joinChannel(null, widget.call.channelId, null, 0);
//   }
//   Future<void> _initAgoraRtcEngine() async {
//     await AgoraRtcEngine.create(APP_ID);
//     await AgoraRtcEngine.enableVideo();
//     await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await AgoraRtcEngine.setClientRole(widget.role);
//   } /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     await AgoraRtcEngine.create(APP_ID);
//     await AgoraRtcEngine.enableVideo();
//     await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await AgoraRtcEngine.setClientRole(widget.role);
//   }

//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     AgoraRtcEngine.onError = (dynamic code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     };

//     AgoraRtcEngine.onJoinChannelSuccess = (
//       String channel,
//       int uid,
//       int elapsed,
//     ) {
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//       });
//     };

//     AgoraRtcEngine.onLeaveChannel = () {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     };

//     AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     };

//     AgoraRtcEngine.onUserOffline = (int uid, int reason) {
//       callMethods.endCall(call:widget.call);
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//     };

//     AgoraRtcEngine.onFirstRemoteVideoFrame = (
//       int uid,
//       int width,
//       int height,
//       int elapsed,
//     ) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//       });
//     };
//   }
//   addPostFrameCallback(){
//     SchedulerBinding.instance.addPostFrameCallback((_) { 
//       userProvider= Provider.of<UserProvider>(context,listen:false);

// callStreamSubscriptions= callMethods.callStream(uid:userProvider.getUser.uid)
// .listen((DocumentSnapshot ds) {
// switch(ds.data){
//   case null:
//   Navigator.pop(context);
//   break;
//   default:
//   break;
// }


// });

//     });
//   }



//  /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<AgoraRenderWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(AgoraRenderWidget(0, local: true, preview: true));
//     }
//     _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
//     return list;
//   }

//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]])
//           ],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }
  
//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return null;
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//    void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     AgoraRtcEngine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     AgoraRtcEngine.switchCamera();
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () =>callMethods.endCall(call:widget.call),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }

//   @override

// void dispose(){
 
//      // clear users
//     _users.clear();
//     // destroy sdk
//     AgoraRtcEngine.leaveChannel();
//     AgoraRtcEngine.destroy();
//   callStreamSubscriptions.cancel(); 
//   super.dispose();
// }

//   @override

//   Widget build(BuildContext context) {
//     return Scaffold(
//      backgroundColor: Colors.black,
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _viewRows(),
//             _panel(),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }
// }