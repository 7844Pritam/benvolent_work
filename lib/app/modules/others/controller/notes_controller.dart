import 'package:benevolent_crm_app/app/modules/converted_call/modal/request_notes_modal.dart';
import 'package:benevolent_crm_app/app/services/notes_services.dart';
import 'package:get/get.dart';

class NotesController extends GetxController {
  final NotesServices _notesService = NotesServices();

  final RxBool isLoading = false.obs;

  Future<void> addNotes(int leadId, String comment) async {
    if (isLoading.value) return;
    print(leadId);
    print(comment);
    try {
      isLoading(true);

      final res = await _notesService.addNotes(
        RequestNotesModal(leadId: leadId, newComments: comment),
      );

      final ok = (res.success == true) || (res.success == 200);

      if (ok) {
        Get.snackbar("Success", res.message);
      } else {
        Get.snackbar("Error", res.message);
      }
    } catch (e) {
      print("Error in adding notesdsfdsf: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
