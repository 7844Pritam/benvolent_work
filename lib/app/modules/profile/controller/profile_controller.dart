import 'package:benevolent_crm_app/app/services/profile_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../modals/profile_modal.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  var pickedImageFilePath = ''.obs;

  var profile = Rxn<Profile>();
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isUploadingImage = false.obs;
  var isChangingAvailability = false.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final result = await _profileService.fetchProfile();
      profile.value = result.data;

      firstNameController.text = result.data.firstName;
      lastNameController.text = result.data.lastName;
      emailController.text = result.data.email;
      phoneController.text = result.data.phone.toString();
      userIdController.text = result.data.id.toString();
      imageUrlController.text = result.data.imageUrl;
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isUpdating.value = true;
      if (pickedImageFilePath.isNotEmpty) {
        await uploadProfileImage(XFile(pickedImageFilePath.value));
        imageUrlController.text = pickedImageFilePath.value;
      }

      final updatedProfile = Profile(
        id: profile.value?.id ?? 0,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: profile.value?.address,
        availability: profile.value?.availability ?? "",
        atContact: profile.value?.atContact,
        dob: profile.value?.dob,
        imageUrl: imageUrlController.text,
      );

      await _profileService.updateProfile(updatedProfile);
      profile.value = updatedProfile;
      pickedImageFilePath.value = '';

      CustomSnackbar.show(
        title: "Success",
        message: "Profile updated successfully",
      );
    } catch (e) {
      CustomSnackbar.show(
        title: "Update Failed",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> uploadProfileImage(XFile imageFile) async {
    try {
      isUploadingImage.value = true;
      await _profileService.uploadProfilePicture(imageFile.path);
      CustomSnackbar.show(title: "Success", message: "Profile picture updated");
    } catch (e) {
      CustomSnackbar.show(
        title: "Upload Failed",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        pickedImageFilePath.value = pickedFile.path;
      }
    } catch (e) {
      CustomSnackbar.show(
        title: "Image Error",
        message: e.toString(),
        type: ToastType.error,
      );
    }
  }

  Future<void> changeAvailability(String status) async {
    try {
      isChangingAvailability.value = true;
      await _profileService.updateAvailability(status);
      profile.update((val) {
        if (val != null) val.availability = status;
      });
      CustomSnackbar.show(
        title: "Updated",
        message: "Availability changed to $status",
      );
    } catch (e) {
      CustomSnackbar.show(
        title: "Failed",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isChangingAvailability.value = false;
    }
  }
}
