import 'package:benevolent_crm_app/app/modules/profile/modals/profile_modal.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final ApiClient _apiClient;

  ProfileService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// GET Profile
  Future<ProfileResponse> fetchProfile() async {
    try {
      final response = await _apiClient.get('/edit-profile');
      final jsonData = response.data;
      print("from profile service");
      print(jsonData);
      return ProfileResponse.fromJson(jsonData);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  /// UPDATE Profile
  Future<void> updateProfile(Profile profile) async {
    try {
      await _apiClient.post('/update-profile', data: profile.toJson());
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Upload Profile Picture
  Future<void> uploadProfilePicture(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'user_profile': await MultipartFile.fromFile(filePath),
      });

      await _apiClient.post('/photo-upload', data: formData);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Change Availability
  Future<void> updateAvailability(String status) async {
    try {
      await _apiClient.post(
        '/change-availability',
        data: {'availability': status},
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
