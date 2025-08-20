import 'package:benevolent_crm_app/app/modules/converted_call/modal/request_notes_modal.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/modal/response_notes_modal.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class NotesServices {
  final ApiClient _apiClient;
  NotesServices({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<AddNoteResponse> addNotes(RequestNotesModal request) async {
    print("notes se aa rahe hai");
    print(request.toJson());
    try {
      final response = await _apiClient.post(
        ApiEndPoints.ADD_NOTES,
        data: request.toJson(),
      );
      return AddNoteResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("Error in adding notes: ${e.message}");
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
