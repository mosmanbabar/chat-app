import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class ChatBoxLogic extends GetxController {
  final ChatBoxState state = ChatBoxState();

  ScrollController scrollController = ScrollController();
  TextEditingController sendMessageController = TextEditingController();

  sendNotification(String token, String? msg, String name) async {
    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAock1DAg:APA91bGse99SBZSQejtxOiRSkjKkkNuJjPJ_Q2Smk4KsXGY0xr5Q'
                'u19HxocmsdUZz-CeOFagY-msA75ecRRogM2YtH7RENLd7OJZyGQKaMXeE-2CNr0QAPEtRiN4iUXvnwJWkBOU9FIe',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$msg',
            'title': 'Message from ${name.toUpperCase()}'
          },
          'priority': 'high',
          'data': <String, dynamic>{},
          'to': token
        },
      ),
    );
  }
}
