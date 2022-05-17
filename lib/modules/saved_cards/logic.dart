import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class SavedCardsLogic extends GetxController {
  final state = SavedCardsState();

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();
  TextEditingController cardCVCController = TextEditingController();
}
