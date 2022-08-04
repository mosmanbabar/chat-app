import 'package:chat_task_ronaq/modules/chat_box/view.dart';
import 'package:chat_task_ronaq/modules/login/view.dart';
import 'package:chat_task_ronaq/modules/sign_up/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

routes() => [
      GetPage(name: "/login", page: () => const LoginPage()),
      GetPage(name: "/signUp", page: () => const SignUpPage()),
      GetPage(name: "/chatBox", page: () => const ChatBoxPage()),
    ];

class PageRoutes {
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String chatBox = '/chatBox';

  Map<String, WidgetBuilder> routes() {
    return {
      login: (context) => const LoginPage(),
      signUp: (context) => const SignUpPage(),
      chatBox: (context) => const ChatBoxPage(),
    };
  }
}
