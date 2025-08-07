class SchedulesResponseModel {
  final int success;
  final String message;
  final List<ScheduleModel> data;

  SchedulesResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SchedulesResponseModel.fromJson(Map<String, dynamic> json) {
    return SchedulesResponseModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => ScheduleModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ScheduleModel {
  final int id;
  final int leadId;
  final String? iHaveDone;
  final String? interestedProjects;
  final String? clientPriority;
  final String planToDo;
  final String scheduleTime;
  final String scheduleDate;
  final int? reminderSent;
  final String? joinWithEmployee;
  final int agentId;
  final String? comment;
  final String? followupStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleModel({
    required this.id,
    required this.leadId,
    this.iHaveDone,
    this.interestedProjects,
    this.clientPriority,
    required this.planToDo,
    required this.scheduleTime,
    required this.scheduleDate,
    this.reminderSent,
    this.joinWithEmployee,
    required this.agentId,
    this.comment,
    this.followupStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      leadId: json['lead_id'] ?? 0,
      iHaveDone: json['i_have_done'],
      interestedProjects: json['interested_projects'],
      clientPriority: json['client_priority'],
      planToDo: json['plan_to_do'] ?? '',
      scheduleTime: json['schedule_time'] ?? '',
      scheduleDate: json['schedule_date'] ?? '',
      reminderSent: json['reminder_sent'],
      joinWithEmployee: json['join_with_employee'],
      agentId: json['agent_id'] ?? 0,
      comment: json['comment'],
      followupStatus: json['followup_status'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lead_id': leadId,
      'i_have_done': iHaveDone,
      'interested_projects': interestedProjects,
      'client_priority': clientPriority,
      'plan_to_do': planToDo,
      'schedule_time': scheduleTime,
      'schedule_date': scheduleDate,
      'reminder_sent': reminderSent,
      'join_with_employee': joinWithEmployee,
      'agent_id': agentId,
      'comment': comment,
      'followup_status': followupStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
