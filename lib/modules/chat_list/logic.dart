import 'dart:developer';

import 'package:chat_task_ronaq/controller/general_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'state.dart';

class ChatListLogic extends GetxController {
  final ChatListState state = ChatListState();

  User? currentUser;
  String? fcmToken;
  String? userName;

  updateUserName(String? name) {
    userName = name;
    update();
  }

  updateToken() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (!Get.find<GeneralController>().boxStorage.hasData('fcmToken')) {
      log('currentUser--->> ${currentUser!.email}');
      await FirebaseMessaging.instance.getToken().then((value) {
        fcmToken = value;
        Get.find<GeneralController>().boxStorage.write('fcmToken', 'Exist');
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'token': fcmToken});
    }
    if (!Get.find<GeneralController>().boxStorage.hasData('name')) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get()
          .then((value) {
        log('---Bt>>${value.get('name')}');
        Get.find<GeneralController>()
            .boxStorage
            .write('name', value.get('name'));
        updateUserName(value.get('name'));
      });
    } else {
      updateUserName(Get.find<GeneralController>().boxStorage.read('name'));
    }
  }
}
