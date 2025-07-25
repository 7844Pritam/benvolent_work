import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/leads_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';

class LeadsController extends GetxController {
  final LeadsService _leadService = LeadsService();

  var leads = <Lead>[].obs;
  var selectedLead = Rxn<Lead>();
  var isLoading = false.obs;
  var isCreating = false.obs;
  var isUpdating = false.obs;
  var isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    try {
      LeadRequestModel requestModel = LeadRequestModel(
        agentId: "",
        fromDate: "",
        toDate: "",
        developerId: "",
        propertyId: "",
        status: "",
        campaign: "",
        priority: "",
        keyword: "",
      );
      isLoading.value = true;
      final result = await _leadService.fetchLeads(requestModel);
      leads.value = result.data.data;
    } catch (e) {
      print("eororororororororor");
      print(e.toString());
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
