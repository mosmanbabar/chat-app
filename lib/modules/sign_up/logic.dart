import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class SignUpLogic extends GetxController {
  final state = SignUpState();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
}
