import 'dart:developer';

import 'package:chat_task_ronaq/controller/general_controller.dart';
import 'package:chat_task_ronaq/controller/notification_controller.dart';
import 'package:chat_task_ronaq/modules/chat_list/view.dart';
import 'package:chat_task_ronaq/modules/login/view.dart';
import 'package:chat_task_ronaq/route_generator.dart';
import 'package:chat_task_ronaq/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  Get.put(GeneralController());
  LocalNotificationService.display(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put(GeneralController());

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  Get.find<GeneralController>().boxStorage.write(
      'server_key',
      'AAAAock1DAg:APA91bGse99SBZ'
          'SQejtxOiRSkjKkkNuJjPJ_Q2Smk4KsXGY0xr5Qu19Hxo'
          'cmsdUZz-CeOFagY-msA75ecRRogM2YtH7RENLd7OJZyGQKaMXeE-2CNr0QAPEtRiN4iUXvnwJWkBOU9FIe');

  runApp(const InitClass());
}

class InitClass extends StatefulWidget {
  const InitClass({Key? key}) : super(key: key);

  @override
  _InitClassState createState() => _InitClassState();
}

class _InitClassState extends State<InitClass> {
  @override
  void initState() {
    super.initState();
    // LocalNotificationService.initialize(context);

    /// on app closed
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    ///forground messages
    FirebaseMessaging.onMessage.listen((message) {
      log('foreground messages----->>');
      log(message.notification.toString());
      if (message.notification != null) {
        log(message.notification!.body.toString());
        log(message.notification!.title.toString());
      }

      LocalNotificationService.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScreenController(),
      getPages: routes(),
      themeMode: ThemeMode.light,
      theme: lightTheme(),
    );
  }
}

class ScreenController extends StatelessWidget {
  const ScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<GeneralController>().boxStorage.hasData('session')) {
      return const ChatListPage();
    } else {
      return const LoginPage();
    }
  }
}
