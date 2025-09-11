import 'package:benevolent_crm_app/app/modules/dashboard/modals/dashboard_model.dart';
import 'package:benevolent_crm_app/app/services/dashboard_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = DashboardService();

  final Rx<DashboardModel> dashboardModel = DashboardModel(
    success: 0,
    totColdCall: 0,
    totLeads: 0,
    totProperties: 0,
    featuredProperties: [],
    message: '',
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
      print(data.featuredProperties.map((data) => data));
      CustomSnackbar.show(
        title: 'Success',
        message: data.message,
        type: ToastType.success,
      );
    } catch (e) {
      print('Error fetching dashboard data: $e');
      // CustomSnackbar.show(
      //   title: 'Error',
      //   message: e.toString(),
      //   type: ToastType.error,
      // );
    } finally {
      isLoading.value = false;
    }
  }
}
