import 'package:get/get.dart';
import '../controllers/campaign_summary_controller.dart';

class CampaignSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignSummaryController>(
      () => CampaignSummaryController(),
    );
  }
}
