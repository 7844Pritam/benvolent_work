class LeadResponseModel {
  final int success;
  final String message;
  final int count;
  final Leads data;

  LeadResponseModel({
    required this.success,
    required this.message,
    required this.count,
    required this.data,
  });

  factory LeadResponseModel.fromJson(Map<String, dynamic> json) {
    return LeadResponseModel(
      success: json['success'],
      message: json['message'],
      count: json['count'],
      data: Leads.fromJson(json['data']),
    );
  }
}

class Leads {
  final int currentPage;
  final List<Lead> leads;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  Leads({
    required this.currentPage,
    required this.leads,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Leads.fromJson(Map<String, dynamic> json) {
    return Leads(
      currentPage: json['current_page'],
      leads: List<Lead>.from(json['data'].map((x) => Lead.fromJson(x))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class Lead {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? date;
  final int statusId;
  final String status;
  final String campaign;
  final int compaignId;
  final int agentId;
  final String agent;

  Lead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.statusId,
    required this.status,
    required this.campaign,
    required this.compaignId,
    required this.agentId,
    required this.agent,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      date: json['date'],
      statusId: json['status_id'],
      status: json['status'],
      campaign: json['campaign'],
      compaignId: json['compaign_id'],
      agentId: json['agent_id'],
      agent: json['agent'],
    );
  }
}

// class LeadResponseModel {
//   final int success;
//   final String message;
//   final int count;
//   final List<Lead> data;

//   LeadResponseModel({
//     required this.success,
//     required this.message,
//     required this.count,
//     required this.data,
//   });

//   factory LeadResponseModel.fromJson(Map<String, dynamic> json) {
//     return LeadResponseModel(
//       success: json['success'],
//       message: json['message'],
//       count: json['count'],
//       data: List<Lead>.from(json['data'].map((x) => Lead.fromJson(x))),
//     );
//   }
// }

// class Lead {
//   final int id;
//   final String name;
//   final String email;
//   final String phone;
//   final String? date;
//   final int statusId;
//   final String status;
//   final String campaign;
//   final int compaignId;
//   final int agentId;
//   final String agent;

//   Lead({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.date,
//     required this.statusId,
//     required this.status,
//     required this.campaign,
//     required this.compaignId,
//     required this.agentId,
//     required this.agent,
//   });

//   factory Lead.fromJson(Map<String, dynamic> json) {
//     return Lead(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       date: json['date'],
//       statusId: json['status_id'],
//       status: json['status'],
//       campaign: json['campaign'],
//       compaignId: json['compaign_id'],
//       agentId: json['agent_id'],
//       agent: json['agent'],
//     );
//   }
// }

// class LeadResponseModel {
//   final int success;
//   final int count;
//   final LeadData data;
//   final String message;

//   LeadResponseModel({
//     required this.success,
//     required this.count,
//     required this.data,
//     required this.message,
//   });

//   factory LeadResponseModel.fromJson(Map<String, dynamic> json) {
//     return LeadResponseModel(
//       success: json['success'],
//       count: json['count'],
//       data: LeadData.fromJson(json['data']),
//       message: json['message'],
//     );
//   }
// }

// class LeadData {
//   final int currentPage;
//   final List<Lead> data;

//   LeadData({required this.currentPage, required this.data});

//   factory LeadData.fromJson(Map<String, dynamic> json) {
//     return LeadData(
//       currentPage: json['current_page'],
//       data: (json['data'] as List).map((e) => Lead.fromJson(e)).toList(),
//     );
//   }
// }

// class Lead {
//   final int id;
//   final String name;
//   final String email;
//   final String phone;
//   final String priority;
//   final String? date;
//   final int status;
//   final String type;
//   final String leadId;
//   final List<Agent> agents;
//   final Status? statuses;
//   final Campaign? campaign;

//   Lead({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.priority,
//     required this.date,
//     required this.status,
//     required this.type,
//     required this.leadId,
//     required this.agents,
//     required this.statuses,
//     required this.campaign,
//   });

//   factory Lead.fromJson(Map<String, dynamic> json) {
//     return Lead(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       priority: json['priority'] ?? '',
//       date: json['date'],
//       status: json['status'],
//       type: json['type'] ?? '',
//       leadId: json['lead_id'] ?? '',
//       agents: (json['agents'] as List).map((e) => Agent.fromJson(e)).toList(),
//       statuses: json['statuses'] != null
//           ? Status.fromJson(json['statuses'])
//           : null,
//       campaign: json['campaign'] != null
//           ? Campaign.fromJson(json['campaign'])
//           : null,
//     );
//   }
// }

// class Agent {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final int phone;
//   final String department;
//   final String status;
//   final String? userProfile;

//   Agent({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//     required this.department,
//     required this.status,
//     this.userProfile,
//   });

//   factory Agent.fromJson(Map<String, dynamic> json) {
//     return Agent(
//       id: json['id'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//       email: json['email'],
//       phone: json['phone'],
//       department: json['department'] ?? '',
//       status: json['status'],
//       userProfile: json['user_profile'],
//     );
//   }
// }

// class Status {
//   final int id;
//   final String name;
//   final String color;

//   Status({required this.id, required this.name, required this.color});

//   factory Status.fromJson(Map<String, dynamic> json) {
//     return Status(id: json['id'], name: json['name'], color: json['color']);
//   }
// }

// class Campaign {
//   final int id;
//   final String name;
//   final String secondaryName;

//   Campaign({required this.id, required this.name, required this.secondaryName});

//   factory Campaign.fromJson(Map<String, dynamic> json) {
//     return Campaign(
//       id: json['id'],
//       name: json['name'],
//       secondaryName: json['secondary_name'],
//     );
//   }
// }
