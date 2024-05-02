import 'dart:io';
import 'dart:math';

import 'package:Chromser/Screens/classifications/chat/enum/user_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Utilities {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getIntitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameIntial = nameSplit[0][0];
    String lastNameInitials = nameSplit[1][0];
    return firstNameIntial + lastNameInitials;
  }

  // static Future<File> pickImage({required ImageSource source}) async {
  //   ImagePicker imagePicker = ImagePicker();
  //   print("starttttttt");
  //   XFile? selectedImage = await imagePicker.pickImage(source: source);
  //   if (selectedImage != null) {
  //     File file = File(selectedImage.path);
  //     //File compressFile =await compressImage(file);
  //      //print(compressFile.uri.toString()+"middddddd2");
  //     return file;
  //   } else {
  //     print("imagefilllllleo");
  //     throw Exception('No image selected');
  //   }
  // }

  // static Future<File> compressImage(File imageToCompress) async {
  //   String path="/assets/db";
  //   if(!kIsWeb){
  //   Directory tempOir = await getTemporaryDirectory();
  //   print("hiiii");
  //   path = tempOir.path;
  //   }
  //   int random = Random().nextInt(1000);

  //   Im.Image? image = Im.decodeImage(imageToCompress.readAsBytesSync());
  //   Im.copyResize(image!, width: 500, height: 500);

  //   return new File('$path/img_$random.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  // }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;
      case UserState.OnliNE:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.OnliNE;
      default:
        return UserState.Waiting;
    }
  }
}
