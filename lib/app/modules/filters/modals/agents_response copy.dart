// class AgentsResponse {
//   final int success;
//   final String message;
//   final Map<String, dynamic> data;

//   AgentsResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory AgentsResponse.fromJson(Map<String, dynamic> json) {
//     return AgentsResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'],
//     );
//   }
// }

// class GroupedAgentsResponse {
//   final int success;
//   final String message;
//   final String allLabel;
//   final List<AgentGroup> groups;

//   GroupedAgentsResponse({
//     required this.success,
//     required this.message,
//     required this.allLabel,
//     required this.groups,
//   });

//   factory GroupedAgentsResponse.fromJson(Map<String, dynamic> json) {
//     final Map<String, dynamic> data = json['data'];
//     final String allLabel = data[''] ?? 'All';

//     final List<AgentGroup> groups = [];
//     data.forEach((key, value) {
//       if (key.isNotEmpty && value is Map<String, dynamic>) {
//         groups.add(
//           AgentGroup(groupName: key, agents: Map<String, String>.from(value)),
//         );
//       }
//     });

//     return GroupedAgentsResponse(
//       success: json['success'],
//       message: json['message'],
//       allLabel: allLabel,
//       groups: groups,
//     );
//   }
// }

// class AgentGroup {
//   final String groupName;
//   final Map<String, String> agents;

//   AgentGroup({required this.groupName, required this.agents});
// }

// second time

// class AgentsResponse {
//   final int success;
//   final String message;
//   final List<AgentGroup> data;

//   AgentsResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory AgentsResponse.fromJson(Map<String, dynamic> json) {
//     final groups = <AgentGroup>[];
//     if (json['data'] != null) {
//       (json['data'] as Map<String, dynamic>).forEach((groupName, value) {
//         if (value is Map<String, dynamic>) {
//           groups.add(
//             AgentGroup(
//               groupName: groupName,
//               agents: value.entries
//                   .map(
//                     (e) => Agent(
//                       id: int.tryParse(e.key) ?? 0,
//                       name: e.value.toString(),
//                     ),
//                   )
//                   .toList(),
//             ),
//           );
//         } else {
//           // For "" : "All"
//           groups.add(
//             AgentGroup(
//               groupName: groupName,
//               agents: [Agent(id: 0, name: value.toString())],
//             ),
//           );
//         }
//       });
//     }
//     return AgentsResponse(
//       success: json['success'] ?? 0,
//       message: json['message'] ?? '',
//       data: groups,
//     );
//   }
// }

// class AgentGroup {
//   final String groupName;
//   final List<Agent> agents;

//   AgentGroup({required this.groupName, required this.agents});
// }

// class Agent {
//   final int id;
//   final String name;

//   Agent({required this.id, required this.name});
// }

// ////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////

import 'dart:convert';

class AgentsResponse {
  final int success;
  final String message;
  final String role;
  final List<Agent> data;

  AgentsResponse({
    required this.success,
    required this.message,
    required this.role,
    required this.data,
  });

  factory AgentsResponse.fromJson(Map<String, dynamic> json) {
    return AgentsResponse(
      success: json['success'] as int,
      message: json['message'] as String,
      role: json['role'] as String,
      data: (json['data'] as List)
          .map((item) => Agent.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'role': role,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Agent {
  final int id;
  final String? firstName;
  final String? lastName;
  final String fullName;
  final MetaData? metaData;
  final List<Meta>?
  metas; // Only present in some entries (e.g., id: 825, 832, etc.)

  Agent({
    required this.id,
    this.firstName,
    this.lastName,
    required this.fullName,
    this.metaData,
    this.metas,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as int,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      fullName: json['full_name'] as String,
      metaData: json['meta_data'] != null
          ? MetaData.fromJson(json['meta_data'] as Map<String, dynamic>)
          : null,
      metas: json['metas'] != null
          ? (json['metas'] as List)
                .map((e) => Meta.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'meta_data': metaData?.toJson(),
      if (metas != null) 'metas': metas!.map((e) => e.toJson()).toList(),
    };
  }
}

class MetaData {
  final String? indianNumber;
  final String? dob;
  final String? bloodGroup;
  final String? personalEmail;
  final String? emergencyNumber;
  final String? passportNumber;
  final String? passportExpiryDate;
  final String? visaNumber;
  final String? visaExpiryDate;
  final String? bankName;
  final String? bankIfsc;
  final String? accountNumber;
  final String? addressInUae;
  final String? emergencyContactName;
  final String? emergencyContactRelationship;
  final String? nationality;
  final String? medicalConditions;
  final String? maritalStatus;
  final String? visaType;
  final String? educationDetails;

  MetaData({
    this.indianNumber,
    this.dob,
    this.bloodGroup,
    this.personalEmail,
    this.emergencyNumber,
    this.passportNumber,
    this.passportExpiryDate,
    this.visaNumber,
    this.visaExpiryDate,
    this.bankName,
    this.bankIfsc,
    this.accountNumber,
    this.addressInUae,
    this.emergencyContactName,
    this.emergencyContactRelationship,
    this.nationality,
    this.medicalConditions,
    this.maritalStatus,
    this.visaType,
    this.educationDetails,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      indianNumber: json['indian_number'] as String?,
      dob: json['dob'] as String?,
      bloodGroup: json['blood_group'] as String?,
      personalEmail: json['personal_email'] as String?,
      emergencyNumber: json['emergency_number'] as String?,
      passportNumber: json['passport_number'] as String?,
      passportExpiryDate: json['passport_expiry_date'] as String?,
      visaNumber: json['visa_number'] as String?,
      visaExpiryDate: json['visa_expiry_date'] as String?,
      bankName: json['bank_name'] as String?,
      bankIfsc: json['bank_ifsc'] as String?,
      accountNumber: json['account_number'] as String?,
      addressInUae: json['address_in_uae'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactRelationship:
          json['emergency_contact_relationship'] as String?,
      nationality: json['nationality'] as String?,
      medicalConditions: json['medical_conditions'] as String?,
      maritalStatus: json['marital_status'] as String?,
      visaType: json['visa_type'] as String?,
      educationDetails: json['education_details'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'indian_number': indianNumber,
      'dob': dob,
      'blood_group': bloodGroup,
      'personal_email': personalEmail,
      'emergency_number': emergencyNumber,
      'passport_number': passportNumber,
      'passport_expiry_date': passportExpiryDate,
      'visa_number': visaNumber,
      'visa_expiry_date': visaExpiryDate,
      'bank_name': bankName,
      'bank_ifsc': bankIfsc,
      'account_number': accountNumber,
      'address_in_uae': addressInUae,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_relationship': emergencyContactRelationship,
      'nationality': nationality,
      'medical_conditions': medicalConditions,
      'marital_status': maritalStatus,
      'visa_type': visaType,
      'education_details': educationDetails,
    };
  }
}

class Meta {
  final int id;
  final int userId;
  final String? type;
  final String key;
  final dynamic value; // Can be String or null
  final DateTime createdAt;
  final DateTime updatedAt;

  Meta({
    required this.id,
    required this.userId,
    this.type,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: json['type'] as String?,
      key: json['key'] as String,
      value: json['value'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'key': key,
      'value': value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// class AgentsResponse {
//   final int success;
//   final String message;
//   final String? role;
//   final List<Agent> data;

//   AgentsResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//     this.role,
//   });

//   factory AgentsResponse.fromJson(Map<String, dynamic> json) {
//     final List<dynamic> dataList = json['data'] ?? [];
//     return AgentsResponse(
//       success: json['success'] ?? 0,
//       message: json['message'] ?? '',
//       role: json['role'],
//       data: dataList.map((e) => Agent.fromJson(e)).toList(),
//     );
//   }
// }

// class Agent {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String fullName;
//   final MetaData metaData;

//   Agent({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.fullName,
//     required this.metaData,
//   });

//   factory Agent.fromJson(Map<String, dynamic> json) {
//     return Agent(
//       id: json['id'] ?? 0,
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       fullName: json['full_name'] ?? '',
//       metaData: MetaData.fromJson(json['meta_data'] ?? {}),
//     );
//   }
// }

// class MetaData {
//   final String? indianNumber;
//   final String? dob;
//   final String? bloodGroup;
//   final String? personalEmail;
//   final String? emergencyNumber;
//   final String? passportNumber;
//   final String? passportExpiryDate;
//   final String? visaNumber;
//   final String? visaExpiryDate;
//   final String? bankName;
//   final String? bankIfsc;
//   final String? accountNumber;
//   final String? addressInUae;
//   final String? emergencyContactName;
//   final String? emergencyContactRelationship;
//   final String? nationality;
//   final String? medicalConditions;
//   final String? maritalStatus;
//   final String? visaType;
//   final String? educationDetails;

//   MetaData({
//     this.indianNumber,
//     this.dob,
//     this.bloodGroup,
//     this.personalEmail,
//     this.emergencyNumber,
//     this.passportNumber,
//     this.passportExpiryDate,
//     this.visaNumber,
//     this.visaExpiryDate,
//     this.bankName,
//     this.bankIfsc,
//     this.accountNumber,
//     this.addressInUae,
//     this.emergencyContactName,
//     this.emergencyContactRelationship,
//     this.nationality,
//     this.medicalConditions,
//     this.maritalStatus,
//     this.visaType,
//     this.educationDetails,
//   });

//   factory MetaData.fromJson(Map<String, dynamic> json) {
//     return MetaData(
//       indianNumber: json['indian_number'],
//       dob: json['dob'],
//       bloodGroup: json['blood_group'],
//       personalEmail: json['personal_email'],
//       emergencyNumber: json['emergency_number'],
//       passportNumber: json['passport_number'],
//       passportExpiryDate: json['passport_expiry_date'],
//       visaNumber: json['visa_number'],
//       visaExpiryDate: json['visa_expiry_date'],
//       bankName: json['bank_name'],
//       bankIfsc: json['bank_ifsc'],
//       accountNumber: json['account_number'],
//       addressInUae: json['address_in_uae'],
//       emergencyContactName: json['emergency_contact_name'],
//       emergencyContactRelationship: json['emergency_contact_relationship'],
//       nationality: json['nationality'],
//       medicalConditions: json['medical_conditions'],
//       maritalStatus: json['marital_status'],
//       visaType: json['visa_type'],
//       educationDetails: json['education_details'],
//     );
//   }
// }
