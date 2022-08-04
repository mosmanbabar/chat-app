import 'package:chat_task_ronaq/controller/general_controller.dart';
import 'package:chat_task_ronaq/controller/notification_controller.dart';
import 'package:chat_task_ronaq/modules/chat_box/view.dart';
import 'package:chat_task_ronaq/route_generator.dart';
import 'package:chat_task_ronaq/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final logic = Get.put(ChatListLogic());
  final state = Get.find<ChatListLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.updateToken();
    LocalNotificationService.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListLogic>(
      builder: (_chatListLogic) => Scaffold(
        appBar: AppBar(
          elevation: 10,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
            child: Text(
              'Hi ${_chatListLogic.userName!.toUpperCase()}',
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: customThemeColor),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.find<GeneralController>().boxStorage.erase();
                Get.offAllNamed(PageRoutes.login);
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                child: Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 25,
                ),
              ),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('uid',
                            isNotEqualTo:
                                FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Text(
                            'Record not found',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          );
                        } else {
                          return Column(
                            children: List.generate(snapshot.data!.docs.length,
                                (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 15, 10, 15),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(ChatBoxPage(
                                          userModel: snapshot.data!.docs[index],
                                        ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                                '${snapshot.data!.docs[index].get('name')}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.black)),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 25,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        }
                      } else {
                        return Text(
                          'Record not found',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
