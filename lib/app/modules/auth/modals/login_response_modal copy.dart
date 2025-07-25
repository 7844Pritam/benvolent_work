class LoginResponse {
  int success;
  String message;
  Results results;

  LoginResponse({
    required this.success,
    required this.message,
    required this.results,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as int,
      message: json['message'] as String,
      results: Results.fromJson(json['results'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'results': results.toJson(),
    };
  }
}

class Results {
  String token;
  String tokenType;
  String expiresAt;
  String role;
  UserData data;

  Results({
    required this.token,
    required this.tokenType,
    required this.expiresAt,
    required this.role,
    required this.data,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      token: json['token'] as String,
      tokenType: json['token_type'] as String,
      expiresAt: json['expires_at'] as String,
      role: json['role'] as String,
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'token_type': tokenType,
      'expires_at': expiresAt,
      'role': role,
      'data': data.toJson(),
    };
  }
}

class UserData {
  int id;
  int designationId;
  String firstName;
  String lastName;
  String email;
  String? dob;
  int phone;
  int reportingPerson;
  String? atContact;
  String? address;
  String oldPassword;
  String? deviceToken;
  String userProfile;
  String status;
  String availability;
  String? deviceId;
  int isExcluded;
  int permissionMenu;
  int permissionForCl;
  int permissionForSecondaryLeads;
  String? dataOfJoining;
  String? bloodGroup;
  String? emergencyContactNumber;
  String? emergencyContactName;
  String? emergencyContactRelationship;
  String? addressInUae;
  String? nationality;
  String? medicalConditions;
  String maritalStatus;
  String? visaType;
  String educationDetails;
  int companyId;
  int isTesting;
  String? employeeId;
  String department;
  String? isDisplayWebsite;
  String? orderBy;
  String? createdBy;
  String createdAt;
  int leadExportPermission;
  int leadExportEmailMask;
  int leadExportPhoneMask;
  String fullName;
  List<dynamic> metaData;

  UserData({
    required this.id,
    required this.designationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.dob,
    required this.phone,
    required this.reportingPerson,
    this.atContact,
    this.address,
    required this.oldPassword,
    this.deviceToken,
    required this.userProfile,
    required this.status,
    required this.availability,
    this.deviceId,
    required this.isExcluded,
    required this.permissionMenu,
    required this.permissionForCl,
    required this.permissionForSecondaryLeads,
    this.dataOfJoining,
    this.bloodGroup,
    this.emergencyContactNumber,
    this.emergencyContactName,
    this.emergencyContactRelationship,
    this.addressInUae,
    this.nationality,
    this.medicalConditions,
    required this.maritalStatus,
    this.visaType,
    required this.educationDetails,
    required this.companyId,
    required this.isTesting,
    this.employeeId,
    required this.department,
    this.isDisplayWebsite,
    this.orderBy,
    this.createdBy,
    required this.createdAt,
    required this.leadExportPermission,
    required this.leadExportEmailMask,
    required this.leadExportPhoneMask,
    required this.fullName,
    required this.metaData,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      designationId: json['designation_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      dob: json['dob'] as String?,
      phone: json['phone'] as int,
      reportingPerson: json['reporting_person'] as int,
      atContact: json['at_contact'] as String?,
      address: json['address'] as String?,
      oldPassword: json['old_password'] as String,
      deviceToken: json['device_token'] as String?,
      userProfile: json['user_profile'] as String,
      status: json['status'] as String,
      availability: json['availability'] as String,
      deviceId: json['device_id'] as String?,
      isExcluded: json['is_excluded'] as int,
      permissionMenu: json['permission_menu'] as int,
      permissionForCl: json['permission_for_cl'] as int,
      permissionForSecondaryLeads: json['permission_for_secondaryLeads'] as int,
      dataOfJoining: json['data_of_joining'] as String?,
      bloodGroup: json['blood_group'] as String?,
      emergencyContactNumber: json['emergency_contact_number'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactRelationship:
          json['emergency_contact_relationship'] as String?,
      addressInUae: json['address_in_uae'] as String?,
      nationality: json['nationality'] as String?,
      medicalConditions: json['medical_conditions'] as String?,
      maritalStatus: json['marital_status'] as String,
      visaType: json['visa_type'] as String?,
      educationDetails: json['education_details'] as String,
      companyId: json['company_id'] as int,
      isTesting: json['is_testing'] as int,
      employeeId: json['employeeId'] as String?,
      department: json['department'] as String,
      isDisplayWebsite: json['is_display_website'] as String?,
      orderBy: json['orderBy'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String,
      leadExportPermission: json['lead_export_permission'] as int,
      leadExportEmailMask: json['lead_export_email_mask'] as int,
      leadExportPhoneMask: json['lead_export_phone_mask'] as int,
      fullName: json['full_name'] as String,
      metaData: json['meta_data'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation_id': designationId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'dob': dob,
      'phone': phone,
      'reporting_person': reportingPerson,
      'at_contact': atContact,
      'address': address,
      'old_password': oldPassword,
      'device_token': deviceToken,
      'user_profile': userProfile,
      'status': status,
      'availability': availability,
      'device_id': deviceId,
      'is_excluded': isExcluded,
      'permission_menu': permissionMenu,
      'permission_for_cl': permissionForCl,
      'permission_for_secondaryLeads': permissionForSecondaryLeads,
      'data_of_joining': dataOfJoining,
      'blood_group': bloodGroup,
      'emergency_contact_number': emergencyContactNumber,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_relationship': emergencyContactRelationship,
      'address_in_uae': addressInUae,
      'nationality': nationality,
      'medical_conditions': medicalConditions,
      'marital_status': maritalStatus,
      'visa_type': visaType,
      'education_details': educationDetails,
      'company_id': companyId,
      'is_testing': isTesting,
      'employeeId': employeeId,
      'department': department,
      'is_display_website': isDisplayWebsite,
      'orderBy': orderBy,
      'created_by': createdBy,
      'created_at': createdAt,
      'lead_export_permission': leadExportPermission,
      'lead_export_email_mask': leadExportEmailMask,
      'lead_export_phone_mask': leadExportPhoneMask,
      'full_name': fullName,
      'meta_data': metaData,
    };
  }
}
