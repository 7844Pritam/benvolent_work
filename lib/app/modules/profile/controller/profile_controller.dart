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
  final TextEditingController alternateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    print("ProfileController initialized");
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      print("Loading profile...");
      isLoading.value = true;
      final result = await _profileService.fetchProfile();
      print("Profile fetched: ${result.data}");

      profile.value = result.data;

      firstNameController.text = result.data.firstName;
      lastNameController.text = result.data.lastName;
      emailController.text = result.data.email;
      phoneController.text = result.data.phone.toString();
      userIdController.text = result.data.id.toString();
      imageUrlController.text = result.data.imageUrl;
      alternateController.text = result.data.atContact ?? "";
      addressController.text = result.data.address ?? "";
      print("Profile controllers updated with fetched data.");
    } catch (e) {
      print("Error in loadProfile: $e");
      CustomSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
      print("loadProfile finished.");
    }
  }

  Future<void> updateProfile() async {
    try {
      print("Updating profile...");
      isUpdating.value = true;

      if (pickedImageFilePath.isNotEmpty) {
        print("Uploading new profile image: ${pickedImageFilePath.value}");
        await uploadProfileImage(XFile(pickedImageFilePath.value));
        imageUrlController.text = pickedImageFilePath.value;
      }

      final updatedProfile = Profile(
        id: profile.value?.id ?? 0,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        availability: profile.value?.availability ?? "",
        atContact: alternateController.text,
        dob: profile.value?.dob,
        imageUrl: imageUrlController.text,
      );

      print("Updated profile data: $updatedProfile");

      await _profileService.updateProfile(updatedProfile);
      profile.value = updatedProfile;
      pickedImageFilePath.value = '';

      print("Profile updated successfully on server.");
      CustomSnackbar.show(
        title: "Success",
        message: "Profile updated successfully",
      );
    } catch (e) {
      print("Error in updateProfile: $e");
      CustomSnackbar.show(
        title: "Update Failed",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isUpdating.value = false;
      print("updateProfile finished.");
    }
  }

  Future<void> uploadProfileImage(XFile imageFile) async {
    try {
      print("Uploading image: ${imageFile.path}");
      isUploadingImage.value = true;
      await _profileService.uploadProfilePicture(imageFile.path);
      print("Image uploaded successfully.");
      CustomSnackbar.show(title: "Success", message: "Profile picture updated");
    } catch (e) {
      print("Error in uploadProfileImage: $e");
      CustomSnackbar.show(
        title: "Upload Failed",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isUploadingImage.value = false;
      print("uploadProfileImage finished.");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      print("Picking image from: $source");
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        pickedImageFilePath.value = pickedFile.path;
        print("Picked image path: ${pickedFile.path}");
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error in pickImage: $e");
      CustomSnackbar.show(
        title: "Image Error",
        message: e.toString(),
        type: ToastType.error,
      );
    }
  }

  Future<void> changeAvailability(String status) async {
    try {
      print("Changing availability to: $status");
      isChangingAvailability.value = true;
      await _profileService.updateAvailability(status);

      profile.update((val) {
        if (val != null) val.availability = status;
      });

      print("Availability updated: ${profile.value?.availability}");
      CustomSnackbar.show(
        title: "Updated",
        message: "Availability changed to $status",
      );
    } catch (e) {
      print("Error in changeAvailability: $e");
      CustomSnackbar.show(
        title: "Failed",
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isChangingAvailability.value = false;
      print("changeAvailability finished.");
    }
  }
}
