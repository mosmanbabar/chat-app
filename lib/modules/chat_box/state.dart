import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBoxState {
  TextStyle? messageTextStyle;
  ChatBoxState() {
    ///Initialize variables
    messageTextStyle = GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);
  }
}
