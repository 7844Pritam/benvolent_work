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
  final String source; // <-- new
  final String isFresh; // <-- new  ("1","0","")

  LeadRequestModel({
    this.agentId = '',
    this.fromDate = '',
    this.toDate = '',
    this.developerId = '',
    this.propertyId = '',
    this.status = '',
    this.campaign = '',
    this.priority = '',
    this.keyword = '',
    this.source = '', // new
    this.isFresh = '', // new
  });

  Map<String, dynamic> toJson() => {
    "agent_id": agentId,
    "from_date": fromDate,
    "to_date": toDate,
    "developer_id": developerId,
    "property_id": propertyId,
    "status": status,
    "campaign": campaign,
    "priority": priority,
    "keyword": keyword,
    "source": source, // new
    "is_fresh": isFresh, // new
  };

  LeadRequestModel copyWith({
    String? agentId,
    String? fromDate,
    String? toDate,
    String? developerId,
    String? propertyId,
    String? status,
    String? campaign,
    String? priority,
    String? keyword,
    String? source, // new
    String? isFresh, // new
  }) => LeadRequestModel(
    agentId: agentId ?? this.agentId,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    developerId: developerId ?? this.developerId,
    propertyId: propertyId ?? this.propertyId,
    status: status ?? this.status,
    campaign: campaign ?? this.campaign,
    priority: priority ?? this.priority,
    keyword: keyword ?? this.keyword,
    source: source ?? this.source, // new
    isFresh: isFresh ?? this.isFresh, // new
  );
}
