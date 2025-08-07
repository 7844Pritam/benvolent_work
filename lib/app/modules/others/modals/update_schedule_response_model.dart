class UpdateScheduleResponseModel {
  final bool success;
  final String message;
  final UpdatedScheduleData data;

  UpdateScheduleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateScheduleResponseModel(
      success: json['success'],
      message: json['message'],
      data: UpdatedScheduleData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class UpdatedScheduleData {
  final int id;
  final int leadId;
  final String? iHaveDone;
  final String? interestedProjects;
  final String? clientPriority;
  final String planToDo;
  final String scheduleTime;
  final String scheduleDate;
  final int reminderSent;
  final String? joinWithEmployee;
  final int agentId;
  final String? comment;
  final String followupStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  UpdatedScheduleData({
    required this.id,
    required this.leadId,
    this.iHaveDone,
    this.interestedProjects,
    this.clientPriority,
    required this.planToDo,
    required this.scheduleTime,
    required this.scheduleDate,
    required this.reminderSent,
    this.joinWithEmployee,
    required this.agentId,
    this.comment,
    required this.followupStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpdatedScheduleData.fromJson(Map<String, dynamic> json) {
    return UpdatedScheduleData(
      id: json['id'],
      leadId: json['lead_id'],
      iHaveDone: json['i_have_done'],
      interestedProjects: json['interested_projects'],
      clientPriority: json['client_priority'],
      planToDo: json['plan_to_do'],
      scheduleTime: json['schedule_time'],
      scheduleDate: json['schedule_date'],
      reminderSent: json['reminder_sent'],
      joinWithEmployee: json['join_with_employee'],
      agentId: json['agent_id'],
      comment: json['comment'],
      followupStatus: json['followup_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
