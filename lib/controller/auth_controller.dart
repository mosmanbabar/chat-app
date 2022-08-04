import 'dart:developer';
import 'package:chat_task_ronaq/controller/general_controller.dart';
import 'package:chat_task_ronaq/modules/chat_list/view.dart';
import 'package:chat_task_ronaq/modules/login/logic.dart';
import 'package:chat_task_ronaq/modules/sign_up/logic.dart';
import 'package:chat_task_ronaq/route_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseAuthentication {
  void signInWithEmailAndPassword() async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Get.find<LoginLogic>().emailController.text,
        password: Get.find<LoginLogic>().passwordController.text,
      ))
              .user;
      Get.find<GeneralController>().updateFormLoader(false);
      if (user != null) {
        log(user.uid.toString());
        Get.find<GeneralController>()
            .boxStorage
            .write('uid', user.uid.toString());
        log('user exist');
        Get.find<GeneralController>().boxStorage.write('session', 'active');

        Get.offAll(const ChatListPage());
        Get.find<LoginLogic>().emailController.clear();
        Get.find<LoginLogic>().passwordController.clear();
      } else {
        log('user not found');
        Get.find<GeneralController>().boxStorage.remove('session');
      }
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
      );
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: Get.find<SignUpLogic>().emailController.text,
              password: Get.find<SignUpLogic>().passwordController.text)
          .then((user) {
        Get.find<GeneralController>().boxStorage.write('uid', user.user!.uid);
        _firestore.collection('users').doc(user.user!.uid).set({
          'name': Get.find<SignUpLogic>().nameController.text,
          'email': Get.find<SignUpLogic>().emailController.text,
          'token': '',
          'msgs': [],
          'uid': user.user!.uid,
        });
      });
      Get.find<GeneralController>().updateFormLoader(false);
      Get.find<GeneralController>().boxStorage.write('session', 'active');

      Get.offAll(const ChatListPage());

      Get.find<SignUpLogic>().nameController.clear();
      Get.find<SignUpLogic>().emailController.clear();
      Get.find<SignUpLogic>().passwordController.clear();
      return true;
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
      );
      log(e.toString());
      return false;
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.find<GeneralController>().boxStorage.remove('session');
    Get.find<GeneralController>().boxStorage.remove('uid');
    Get.offAllNamed(PageRoutes.login);
  }
}
