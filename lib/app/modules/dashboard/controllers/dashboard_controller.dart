import 'package:benevolent_crm_app/app/modules/dashboard/modals/dashboard_model.dart';
import 'package:benevolent_crm_app/app/services/dashboard_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = DashboardService();

  final Rx<DashboardModel> dashboardModel = DashboardModel(
    success: 0,
    message: '',
    coldCallCounts: 0,
    coldCallConvertsCounts: 0,
    leadsCounts: 0,
  ).obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    try {
      isLoading.value = true;
      final data = await _dashboardService.dashboardData();
      dashboardModel.value = data;

      print("hellodashboard");
      print(data.leadsCounts); // Example usage

      CustomSnackbar.show(
        title: 'Success',
        message: data.message,
        type: ToastType.success,
      );
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
