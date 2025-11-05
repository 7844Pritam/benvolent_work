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

class AgentsResponse {
  final int success;
  final String message;
  final List<AgentGroup> data;

  AgentsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AgentsResponse.fromJson(Map<String, dynamic> json) {
    final groups = <AgentGroup>[];
    if (json['data'] != null) {
      (json['data'] as Map<String, dynamic>).forEach((groupName, value) {
        if (value is Map<String, dynamic>) {
          groups.add(
            AgentGroup(
              groupName: groupName,
              agents: value.entries
                  .map(
                    (e) => Agent(
                      id: int.tryParse(e.key) ?? 0,
                      name: e.value.toString(),
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          // For "" : "All"
          groups.add(
            AgentGroup(
              groupName: groupName,
              agents: [Agent(id: 0, name: value.toString())],
            ),
          );
        }
      });
    }
    return AgentsResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: groups,
    );
  }
}

class AgentGroup {
  final String groupName;
  final List<Agent> agents;

  AgentGroup({required this.groupName, required this.agents});
}

class Agent {
  final int id;
  final String name;

  Agent({required this.id, required this.name});
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
