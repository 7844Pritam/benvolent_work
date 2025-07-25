class LeadRequestModel {
  final String agentId;
  final String fromDate;
  final String toDate;
  final String developerId;
  final String propertyId;
  final String status;
  final String campaign;
  final String priority;
  final String keyword;

  LeadRequestModel({
    required this.agentId,
    required this.fromDate,
    required this.toDate,
    required this.developerId,
    required this.propertyId,
    required this.status,
    required this.campaign,
    required this.priority,
    required this.keyword,
  });

  Map<String, dynamic> toJson() {
    return {
      'agent_id': agentId,
      'from_date': fromDate,
      'to_date': toDate,
      'developer_id': developerId,
      'property_id': propertyId,
      'status': status,
      'campaign': campaign,
      'priority': priority,
      'keyword': keyword,
    };
  }
}
