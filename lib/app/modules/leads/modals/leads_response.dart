class LeadResponseModel {
  final int success;
  final int count;
  final LeadData data;
  final String message;

  LeadResponseModel({
    required this.success,
    required this.count,
    required this.data,
    required this.message,
  });

  factory LeadResponseModel.fromJson(Map<String, dynamic> json) {
    return LeadResponseModel(
      success: json['success'],
      count: json['count'],
      data: LeadData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class LeadData {
  final int currentPage;
  final List<Lead> data;

  LeadData({required this.currentPage, required this.data});

  factory LeadData.fromJson(Map<String, dynamic> json) {
    return LeadData(
      currentPage: json['current_page'],
      data: (json['data'] as List).map((e) => Lead.fromJson(e)).toList(),
    );
  }
}

class Lead {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String priority;
  final String? date;
  final int status;
  final String type;
  final String leadId;
  final List<Agent> agents;
  final Status? statuses;
  final Campaign? campaign;

  Lead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.priority,
    required this.date,
    required this.status,
    required this.type,
    required this.leadId,
    required this.agents,
    required this.statuses,
    required this.campaign,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      priority: json['priority'] ?? '',
      date: json['date'],
      status: json['status'],
      type: json['type'] ?? '',
      leadId: json['lead_id'] ?? '',
      agents: (json['agents'] as List).map((e) => Agent.fromJson(e)).toList(),
      statuses: json['statuses'] != null
          ? Status.fromJson(json['statuses'])
          : null,
      campaign: json['campaign'] != null
          ? Campaign.fromJson(json['campaign'])
          : null,
    );
  }
}

class Agent {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int phone;
  final String department;
  final String status;
  final String? userProfile;

  Agent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.department,
    required this.status,
    this.userProfile,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      department: json['department'] ?? '',
      status: json['status'],
      userProfile: json['user_profile'],
    );
  }
}

class Status {
  final int id;
  final String name;
  final String color;

  Status({required this.id, required this.name, required this.color});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(id: json['id'], name: json['name'], color: json['color']);
  }
}

class Campaign {
  final int id;
  final String name;
  final String secondaryName;

  Campaign({required this.id, required this.name, required this.secondaryName});

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      name: json['name'],
      secondaryName: json['secondary_name'],
    );
  }
}
