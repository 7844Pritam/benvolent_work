import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
