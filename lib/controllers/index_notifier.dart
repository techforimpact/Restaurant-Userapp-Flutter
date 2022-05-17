import 'package:get/state_manager.dart';

class IndexController extends GetxController{

  int _index = 0;

  int get index => _index;

  set index(int newIndex){

    _index = newIndex;
    update();
  }


}