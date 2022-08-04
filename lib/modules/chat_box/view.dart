import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:chat_task_ronaq/modules/chat_list/logic.dart';
import 'package:chat_task_ronaq/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic.dart';

class ChatBoxPage extends StatefulWidget {
  const ChatBoxPage({Key? key, this.userModel}) : super(key: key);
  final DocumentSnapshot? userModel;

  @override
  _ChatBoxPageState createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  final logic = Get.put(ChatBoxLogic());
  final state = Get.find<ChatBoxLogic>().state;

  bool showSender = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      logic.sendMessageController.clear();
      Future.delayed(const Duration(seconds: 1))
          .whenComplete(() => logic.scrollController.animateTo(
                logic.scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 100),
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatBoxLogic>(
      builder: (_chatBoxLogic) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 5,
          title: Text(
            '${widget.userModel!.get('name')}',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FadedSlideAnimation(
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 61),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FadedScaleAnimation(
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('messages')
                              .orderBy('time')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Record not found!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              } else {
                                return SingleChildScrollView(
                                    controller: _chatBoxLogic.scrollController,
                                    child: Wrap(
                                      children: List.generate(
                                          snapshot.data!.docs.length,
                                          (innerIndex) {
                                        if ((snapshot.data!.docs[innerIndex]
                                                        .get('sender_id')
                                                        .toString() ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                        .toString() &&
                                                snapshot.data!.docs[innerIndex]
                                                        .get('receiver_id')
                                                        .toString() ==
                                                    widget.userModel!
                                                        .get('uid')
                                                        .toString()) ||
                                            (snapshot.data!.docs[innerIndex]
                                                        .get('receiver_id')
                                                        .toString() ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                        .toString() &&
                                                snapshot.data!.docs[innerIndex]
                                                        .get('sender_id')
                                                        .toString() ==
                                                    widget.userModel!
                                                        .get('uid')
                                                        .toString())) {
                                          return Padding(
                                            padding: snapshot
                                                        .data!.docs[innerIndex]
                                                        .get('sender_id')
                                                        .toString() ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                        .toString()
                                                ? const EdgeInsetsDirectional
                                                    .fromSTEB(80, 7, 15, 7)
                                                : const EdgeInsetsDirectional
                                                    .fromSTEB(15, 7, 80, 7),
                                            child: Row(
                                              mainAxisAlignment: snapshot.data!
                                                          .docs[innerIndex]
                                                          .get('sender_id')
                                                          .toString() ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                          .toString()
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: snapshot
                                                                  .data!
                                                                  .docs[
                                                                      innerIndex]
                                                                  .get(
                                                                      'sender_id')
                                                                  .toString() ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                                  .toString()
                                                          ? customThemeColor
                                                          : customLightThemeColor,
                                                      borderRadius: snapshot
                                                                  .data!
                                                                  .docs[
                                                                      innerIndex]
                                                                  .get(
                                                                      'sender_id')
                                                                  .toString() ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                                  .toString()
                                                          ? const BorderRadius
                                                              .only(
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            )
                                                          : const BorderRadius
                                                              .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .all(14.0),
                                                    child: Text(
                                                      '${snapshot.data!.docs[innerIndex].get('msg')}',
                                                      style: snapshot
                                                                  .data!
                                                                  .docs[
                                                                      innerIndex]
                                                                  .get(
                                                                      'sender_id')
                                                                  .toString() ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                                  .toString()
                                                          ? state
                                                              .messageTextStyle
                                                          : state
                                                              .messageTextStyle!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
                                    ));
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
                      durationInMilliseconds: 400,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextFormField(
                  onTap: () {
                    _chatBoxLogic.scrollController.animateTo(
                      _chatBoxLogic.scrollController.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                  controller: _chatBoxLogic.sendMessageController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        showSender = true;
                      });
                    } else {
                      setState(() {
                        showSender = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Write your message here...',
                      hintStyle:
                          GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                      suffixIcon: !showSender
                          ? const SizedBox()
                          : InkWell(
                              onTap: () async {
                                String _friendsToken;
                                String _msg = '';
                                FirebaseFirestore.instance
                                    .collection('messages')
                                    .doc()
                                    .set({
                                  'sender_id':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'receiver_id': widget.userModel!.get('uid'),
                                  'msg':
                                      _chatBoxLogic.sendMessageController.text,
                                  'time': DateTime.now()
                                });
                                _msg = _chatBoxLogic.sendMessageController.text;
                                _chatBoxLogic.sendMessageController.clear();
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.userModel!.get('uid'))
                                    .get()
                                    .then((value) {
                                  _friendsToken = value.get('token');
                                  _chatBoxLogic.sendNotification(
                                    _friendsToken,
                                    _msg,
                                    Get.find<ChatListLogic>().userName!,
                                  );
                                });
                              },
                              child: Icon(
                                Icons.send,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
            ],
          ),
          beginOffset: const Offset(0, 0.3),
          endOffset: const Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }
}
