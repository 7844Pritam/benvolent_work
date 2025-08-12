// // Main response model
// class LeadResponse {
//   final int success;
//   final int count;
//   final LeadData data;
//   final String message;

//   LeadResponse({
//     required this.success,
//     required this.count,
//     required this.data,
//     required this.message,
//   });

//   factory LeadResponse.fromJson(Map<String, dynamic> json) {
//     return LeadResponse(
//       success: json['success'] as int,
//       count: json['count'] as int,
//       data: LeadData.fromJson(json['data'] as Map<String, dynamic>),
//       message: json['message'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'count': count,
//       'data': data.toJson(),
//       'message': message,
//     };
//   }
// }

// // Data model for pagination and leads
// class LeadData {
//   final int currentPage;
//   final List<LeadItem> data;
//   final String firstPageUrl;
//   final int from;
//   final int lastPage;
//   final String lastPageUrl;
//   final String? nextPageUrl;
//   final String path;
//   final int perPage;
//   final String? prevPageUrl;
//   final int to;
//   final int total;

//   LeadData({
//     required this.currentPage,
//     required this.data,
//     required this.firstPageUrl,
//     required this.from,
//     required this.lastPage,
//     required this.lastPageUrl,
//     this.nextPageUrl,
//     required this.path,
//     required this.perPage,
//     this.prevPageUrl,
//     required this.to,
//     required this.total,
//   });

//   factory LeadData.fromJson(Map<String, dynamic> json) {
//     return LeadData(
//       currentPage: json['current_page'] as int,
//       data: (json['data'] as List<dynamic>)
//           .map((item) => LeadItem.fromJson(item as Map<String, dynamic>))
//           .toList(),
//       firstPageUrl: json['first_page_url'] as String,
//       from: json['from'] as int,
//       lastPage: json['last_page'] as int,
//       lastPageUrl: json['last_page_url'] as String,
//       nextPageUrl: json['next_page_url'] as String?,
//       path: json['path'] as String,
//       perPage: json['per_page'] as int,
//       prevPageUrl: json['prev_page_url'] as String?,
//       to: json['to'] as int,
//       total: json['total'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'current_page': currentPage,
//       'data': data.map((item) => item.toJson()).toList(),
//       'first_page_url': firstPageUrl,
//       'from': from,
//       'last_page': lastPage,
//       'last_page_url': lastPageUrl,
//       'next_page_url': nextPageUrl,
//       'path': path,
//       'per_page': perPage,
//       'prev_page_url': prevPageUrl,
//       'to': to,
//       'total': total,
//     };
//   }
// }

// // Lead item model
// class LeadItem {
//   final int id;
//   final int leadId;
//   final int userId;
//   final int isAccepted;
//   final String assignTime;
//   final String? lastActivityTime;
//   final String? deletedAt;
//   final Lead lead;

//   LeadItem({
//     required this.id,
//     required this.leadId,
//     required this.userId,
//     required this.isAccepted,
//     required this.assignTime,
//     this.lastActivityTime,
//     this.deletedAt,
//     required this.lead,
//   });

//   factory LeadItem.fromJson(Map<String, dynamic> json) {
//     return LeadItem(
//       id: json['id'] as int,
//       leadId: json['lead_id'] as int,
//       userId: json['user_id'] as int,
//       isAccepted: json['isAccepted'] as int,
//       assignTime: json['assignTime'] as String,
//       lastActivityTime: json['lastActivityTime'] as String?,
//       deletedAt: json['deleted_at'] as String?,
//       lead: Lead.fromJson(json['lead'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'lead_id': leadId,
//       'user_id': userId,
//       'isAccepted': isAccepted,
//       'assignTime': assignTime,
//       'lastActivityTime': lastActivityTime,
//       'deleted_at': deletedAt,
//       'lead': lead.toJson(),
//     };
//   }
// }

// // Lead model
// class Lead {
//   final int id;
//   final String name;
//   final String email;
//   final String phone;
//   final String? altPhone;
//   final String? additionalPhone;
//   final String date;
//   final String dob;
//   final String source;
//   final String? priority;
//   final String? comment;
//   final String? additionalComment;
//   final int? customerId;
//   final int? developerId;
//   final int? propertyId;
//   final String? propertyPreference;
//   final String? jobProfile;
//   final String? avgIncome;
//   final int status;
//   final String? propertyType;
//   final String? leadMarket;
//   final String? propertyRef;
//   final String? sourcePortal;
//   final String? subStatus;
//   final String? attachment;
//   final String type;
//   final String? subType;
//   final String amount;
//   final String? closedDate;
//   final int? closeBy;
//   final String leadId;
//   final int? agentId;
//   final String? review;
//   final int createdBy;
//   final int assignLeadsCount;
//   final String? previousAgentIds;
//   final int isAccepted;
//   final String? confirmDate;
//   final int cronCount;
//   final int activityCheck;
//   final int compaignId;
//   final int? subSourceId;
//   final int? compaignManagerId;
//   final int? eventId;
//   final int? superStatusId;
//   final int? usedForPromotion;
//   final int? noAnswerStatusCount;
//   final int? needWhatsapp;
//   final int? isFresh;
//   final dynamic property;
//   final List<Agent> agents;
//   final Statuses statuses;
//   final LeadUser leadUser;
//   final Sources sources;
//   final List<NewComment> newComments;
//   final Campaign campaign;

//   Lead({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     this.altPhone,
//     this.additionalPhone,
//     required this.date,
//     required this.dob,
//     required this.source,
//     this.priority,
//     this.comment,
//     this.additionalComment,
//     this.customerId,
//     this.developerId,
//     this.propertyId,
//     this.propertyPreference,
//     this.jobProfile,
//     this.avgIncome,
//     required this.status,
//     this.propertyType,
//     this.leadMarket,
//     this.propertyRef,
//     this.sourcePortal,
//     this.subStatus,
//     this.attachment,
//     required this.type,
//     this.subType,
//     required this.amount,
//     this.closedDate,
//     this.closeBy,
//     required this.leadId,
//     this.agentId,
//     this.review,
//     required this.createdBy,
//     required this.assignLeadsCount,
//     this.previousAgentIds,
//     required this.isAccepted,
//     this.confirmDate,
//     required this.cronCount,
//     required this.activityCheck,
//     required this.compaignId,
//     this.subSourceId,
//     this.compaignManagerId,
//     this.eventId,
//     this.superStatusId,
//     this.usedForPromotion,
//     this.noAnswerStatusCount,
//     this.needWhatsapp,
//     this.isFresh,
//     this.property,
//     required this.agents,
//     required this.statuses,
//     required this.leadUser,
//     required this.sources,
//     required this.newComments,
//     required this.campaign,
//   });

//   factory Lead.fromJson(Map<String, dynamic> json) {
//     print('Lead JSON: $json'); // Log for debugging
//     return Lead(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       email: json['email'] as String,
//       phone: json['phone'] as String,
//       altPhone: json['alt_phone'] as String?,
//       additionalPhone: json['additional_phone'] as String?,
//       date: json['date'] as String,
//       dob: json['dob'] as String,
//       source: json['source'] as String,
//       priority: json['priority'] as String?,
//       comment: json['comment'] as String?,
//       additionalComment: json['additional_comment'] as String?,
//       customerId: json['customer_id'] as int?,
//       developerId: json['developer_id'] as int?,
//       propertyId: json['property_id'] as int?,
//       propertyPreference: json['property_preference'] as String?,
//       jobProfile: json['job_profile'] as String?,
//       avgIncome: json['avg_income'] as String?,
//       status: json['status'] as int,
//       propertyType: json['property_type'] as String?,
//       leadMarket: json['lead_market'] as String?,
//       propertyRef: json['property_ref'] as String?,
//       sourcePortal: json['source_portal'] as String?,
//       subStatus: json['sub_status'] as String?,
//       attachment: json['attachment'] as String?,
//       type: json['type'] as String,
//       subType: json['sub_type'] as String?,
//       amount: json['amount'] as String,
//       closedDate: json['closed_date'] as String?,
//       closeBy: json['close_by'] as int?,
//       leadId: json['lead_id'] as String,
//       agentId: json['agent_id'] as int?,
//       review: json['review'] as String?,
//       createdBy: json['created_by'] as int,
//       assignLeadsCount: json['assign_leads_count'] as int,
//       previousAgentIds: json['previous_agent_ids'] as String?,
//       isAccepted: json['is_accepted'] as int,
//       confirmDate: json['confirm_date'] as String?,
//       cronCount: json['cron_count'] as int,
//       activityCheck: json['activityCheck'] as int,
//       compaignId: json['compaign_id'] as int,
//       subSourceId: json['sub_source_id'] as int?,
//       compaignManagerId: json['compaign_manager_id'] as int?,
//       eventId: json['event_id'] as int?,
//       superStatusId: json['super_status_id'] as int?,
//       usedForPromotion: json['used_for_promotion'] as int?,
//       noAnswerStatusCount: json['no_answer_status_count'] as int?,
//       needWhatsapp: json['need_whatsapp'] as int?,
//       isFresh: json['is_fresh'] as int?,
//       property: json['property'],
//       agents: (json['agents'] as List<dynamic>)
//           .map((item) => Agent.fromJson(item as Map<String, dynamic>))
//           .toList(),
//       statuses: Statuses.fromJson(json['statuses'] as Map<String, dynamic>),
//       leadUser: LeadUser.fromJson(json['lead_user'] as Map<String, dynamic>),
//       sources: Sources.fromJson(json['sources'] as Map<String, dynamic>),
//       newComments: (json['new_comments'] as List<dynamic>)
//           .map((item) => NewComment.fromJson(item as Map<String, dynamic>))
//           .toList(),
//       campaign: Campaign.fromJson(json['campaign'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'alt_phone': altPhone,
//       'additional_phone': additionalPhone,
//       'date': date,
//       'dob': dob,
//       'source': source,
//       'priority': priority,
//       'comment': comment,
//       'additional_comment': additionalComment,
//       'customer_id': customerId,
//       'developer_id': developerId,
//       'property_id': propertyId,
//       'property_preference': propertyPreference,
//       'job_profile': jobProfile,
//       'avg_income': avgIncome,
//       'status': status,
//       'property_type': propertyType,
//       'lead_market': leadMarket,
//       'property_ref': propertyRef,
//       'source_portal': sourcePortal,
//       'sub_status': subStatus,
//       'attachment': attachment,
//       'type': type,
//       'sub_type': subType,
//       'amount': amount,
//       'closed_date': closedDate,
//       'close_by': closeBy,
//       'lead_id': leadId,
//       'agent_id': agentId,
//       'review': review,
//       'created_by': createdBy,
//       'assign_leads_count': assignLeadsCount,
//       'previous_agent_ids': previousAgentIds,
//       'is_accepted': isAccepted,
//       'confirm_date': confirmDate,
//       'cron_count': cronCount,
//       'activityCheck': activityCheck,
//       'compaign_id': compaignId,
//       'sub_source_id': subSourceId,
//       'compaign_manager_id': compaignManagerId,
//       'event_id': eventId,
//       'super_status_id': superStatusId,
//       'used_for_promotion': usedForPromotion,
//       'no_answer_status_count': noAnswerStatusCount,
//       'need_whatsapp': needWhatsapp,
//       'is_fresh': isFresh,
//       'property': property,
//       'agents': agents.map((item) => item.toJson()).toList(),
//       'statuses': statuses.toJson(),
//       'lead_user': leadUser.toJson(),
//       'sources': sources.toJson(),
//       'new_comments': newComments.map((item) => item.toJson()).toList(),
//       'campaign': campaign.toJson(),
//     };
//   }
// }

// // Agent model
// class Agent {
//   final int id;
//   final int designationId;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String? dob;
//   final int phone;
//   final int reportingPerson;
//   final String atContact;
//   final String? address;
//   final String? oldPassword;
//   final String? deviceToken;
//   final String? userProfile;
//   final String status;
//   final String availability;
//   final String? deviceId;
//   final int isExcluded;
//   final int permissionMenu;
//   final int permissionForCl;
//   final int permissionForSecondaryLeads;
//   final String? dataOfJoining;
//   final String? bloodGroup;
//   final String? emergencyContactNumber;
//   final String? emergencyContactName;
//   final String? emergencyContactRelationship;
//   final String? addressInUae;
//   final String? nationality;
//   final String? medicalConditions;
//   final String? maritalStatus;
//   final String? visaType;
//   final String? educationDetails;
//   final int companyId;
//   final int isTesting;
//   final String? employeeId;
//   final String department;
//   final String? isDisplayWebsite;
//   final String? orderBy;
//   final String? createdBy;
//   final String createdAt;
//   final int leadExportPermission;
//   final int leadExportEmailMask;
//   final int leadExportPhoneMask;
//   final String fullName;
//   final Pivot pivot;
//   final MetaData metaData;

//   Agent({
//     required this.id,
//     required this.designationId,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     this.dob,
//     required this.phone,
//     required this.reportingPerson,
//     required this.atContact,
//     this.address,
//     this.oldPassword,
//     this.deviceToken,
//     this.userProfile,
//     required this.status,
//     required this.availability,
//     this.deviceId,
//     required this.isExcluded,
//     required this.permissionMenu,
//     required this.permissionForCl,
//     required this.permissionForSecondaryLeads,
//     this.dataOfJoining,
//     this.bloodGroup,
//     this.emergencyContactNumber,
//     this.emergencyContactName,
//     this.emergencyContactRelationship,
//     this.addressInUae,
//     this.nationality,
//     this.medicalConditions,
//     this.maritalStatus,
//     this.visaType,
//     this.educationDetails,
//     required this.companyId,
//     required this.isTesting,
//     this.employeeId,
//     required this.department,
//     this.isDisplayWebsite,
//     this.orderBy,
//     this.createdBy,
//     required this.createdAt,
//     required this.leadExportPermission,
//     required this.leadExportEmailMask,
//     required this.leadExportPhoneMask,
//     required this.fullName,
//     required this.pivot,
//     required this.metaData,
//   });

//   factory Agent.fromJson(Map<String, dynamic> json) {
//     return Agent(
//       id: json['id'] as int,
//       designationId: json['designation_id'] as int,
//       firstName: json['first_name'] as String,
//       lastName: json['last_name'] as String,
//       email: json['email'] as String,
//       dob: json['dob'] as String?,
//       phone: json['phone'] as int,
//       reportingPerson: json['reporting_person'] as int,
//       atContact: json['at_contact'] as String,
//       address: json['address'] as String?,
//       oldPassword: json['old_password'] as String?,
//       deviceToken: json['device_token'] as String?,
//       userProfile: json['user_profile'] as String?,
//       status: json['status'] as String,
//       availability: json['availability'] as String,
//       deviceId: json['device_id'] as String?,
//       isExcluded: json['is_excluded'] as int,
//       permissionMenu: json['permission_menu'] as int,
//       permissionForCl: json['permission_for_cl'] as int,
//       permissionForSecondaryLeads: json['permission_for_secondaryLeads'] as int,
//       dataOfJoining: json['data_of_joining'] as String?,
//       bloodGroup: json['blood_group'] as String?,
//       emergencyContactNumber: json['emergency_contact_number'] as String?,
//       emergencyContactName: json['emergency_contact_name'] as String?,
//       emergencyContactRelationship:
//           json['emergency_contact_relationship'] as String?,
//       addressInUae: json['address_in_uae'] as String?,
//       nationality: json['nationality'] as String?,
//       medicalConditions: json['medical_conditions'] as String?,
//       maritalStatus: json['marital_status'] as String?,
//       visaType: json['visa_type'] as String?,
//       educationDetails: json['education_details'] as String?,
//       companyId: json['company_id'] as int,
//       isTesting: json['is_testing'] as int,
//       employeeId: json['employeeId'] as String?,
//       department: json['department'] as String,
//       isDisplayWebsite: json['is_display_website'] as String?,
//       orderBy: json['orderBy'] as String?,
//       createdBy: json['created_by'] as String?,
//       createdAt: json['created_at'] as String,
//       leadExportPermission: json['lead_export_permission'] as int,
//       leadExportEmailMask: json['lead_export_email_mask'] as int,
//       leadExportPhoneMask: json['lead_export_phone_mask'] as int,
//       fullName: json['full_name'] as String,
//       pivot: Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
//       metaData: MetaData.fromJson(json['meta_data'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'designation_id': designationId,
//       'first_name': firstName,
//       'last_name': lastName,
//       'email': email,
//       'dob': dob,
//       'phone': phone,
//       'reporting_person': reportingPerson,
//       'at_contact': atContact,
//       'address': address,
//       'old_password': oldPassword,
//       'device_token': deviceToken,
//       'user_profile': userProfile,
//       'status': status,
//       'availability': availability,
//       'device_id': deviceId,
//       'is_excluded': isExcluded,
//       'permission_menu': permissionMenu,
//       'permission_for_cl': permissionForCl,
//       'permission_for_secondaryLeads': permissionForSecondaryLeads,
//       'data_of_joining': dataOfJoining,
//       'blood_group': bloodGroup,
//       'emergency_contact_number': emergencyContactNumber,
//       'emergency_contact_name': emergencyContactName,
//       'emergency_contact_relationship': emergencyContactRelationship,
//       'address_in_uae': addressInUae,
//       'nationality': nationality,
//       'medical_conditions': medicalConditions,
//       'marital_status': maritalStatus,
//       'visa_type': visaType,
//       'education_details': educationDetails,
//       'company_id': companyId,
//       'is_testing': isTesting,
//       'employeeId': employeeId,
//       'department': department,
//       'is_display_website': isDisplayWebsite,
//       'orderBy': orderBy,
//       'created_by': createdBy,
//       'created_at': createdAt,
//       'lead_export_permission': leadExportPermission,
//       'lead_export_email_mask': leadExportEmailMask,
//       'lead_export_phone_mask': leadExportPhoneMask,
//       'full_name': fullName,
//       'pivot': pivot.toJson(),
//       'meta_data': metaData.toJson(),
//     };
//   }
// }

// // Pivot model
// class Pivot {
//   final int leadId;
//   final int userId;
//   final String? deletedAt;
//   final int isAccepted;
//   final String assignTime;
//   final String? lastActivityTime;

//   Pivot({
//     required this.leadId,
//     required this.userId,
//     this.deletedAt,
//     required this.isAccepted,
//     required this.assignTime,
//     this.lastActivityTime,
//   });

//   factory Pivot.fromJson(Map<String, dynamic> json) {
//     return Pivot(
//       leadId: json['lead_id'] as int,
//       userId: json['user_id'] as int,
//       deletedAt: json['deleted_at'] as String?,
//       isAccepted: json['isAccepted'] as int,
//       assignTime: json['assignTime'] as String,
//       lastActivityTime: json['lastActivityTime'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'lead_id': leadId,
//       'user_id': userId,
//       'deleted_at': deletedAt,
//       'isAccepted': isAccepted,
//       'assignTime': assignTime,
//       'lastActivityTime': lastActivityTime,
//     };
//   }
// }

// // MetaData model
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
//       indianNumber: json['indian_number'] as String?,
//       dob: json['dob'] as String?,
//       bloodGroup: json['blood_group'] as String?,
//       personalEmail: json['personal_email'] as String?,
//       emergencyNumber: json['emergency_number'] as String?,
//       passportNumber: json['passport_number'] as String?,
//       passportExpiryDate: json['passport_expiry_date'] as String?,
//       visaNumber: json['visa_number'] as String?,
//       visaExpiryDate: json['visa_expiry_date'] as String?,
//       bankName: json['bank_name'] as String?,
//       bankIfsc: json['bank_ifsc'] as String?,
//       accountNumber: json['account_number'] as String?,
//       addressInUae: json['address_in_uae'] as String?,
//       emergencyContactName: json['emergency_contact_name'] as String?,
//       emergencyContactRelationship:
//           json['emergency_contact_relationship'] as String?,
//       nationality: json['nationality'] as String?,
//       medicalConditions: json['medical_conditions'] as String?,
//       maritalStatus: json['marital_status'] as String?,
//       visaType: json['visa_type'] as String?,
//       educationDetails: json['education_details'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'indian_number': indianNumber,
//       'dob': dob,
//       'blood_group': bloodGroup,
//       'personal_email': personalEmail,
//       'emergency_number': emergencyNumber,
//       'passport_number': passportNumber,
//       'passport_expiry_date': passportExpiryDate,
//       'visa_number': visaNumber,
//       'visa_expiry_date': visaExpiryDate,
//       'bank_name': bankName,
//       'bank_ifsc': bankIfsc,
//       'account_number': accountNumber,
//       'address_in_uae': addressInUae,
//       'emergency_contact_name': emergencyContactName,
//       'emergency_contact_relationship': emergencyContactRelationship,
//       'nationality': nationality,
//       'medical_conditions': medicalConditions,
//       'marital_status': maritalStatus,
//       'visa_type': visaType,
//       'education_details': educationDetails,
//     };
//   }
// }

// class Statuses {
//   final int id;
//   final String name;
//   final int? statusorder;
//   final String color;
//   final int isdefault;
//   final String approveStatus;
//   final int? superStatusId; // Changed to nullable
//   final String createdAt;
//   final String updatedAt;

//   Statuses({
//     required this.id,
//     required this.name,
//     this.statusorder,
//     required this.color,
//     required this.isdefault,
//     required this.approveStatus,
//     this.superStatusId, // Nullable
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Statuses.fromJson(Map<String, dynamic> json) {
//     return Statuses(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       statusorder: json['statusorder'] as int?,
//       color: json['color'] as String,
//       isdefault: json['isdefault'] as int,
//       approveStatus: json['approve_status'] as String,
//       superStatusId: json['super_status_id'] as int? ?? 0, // Default to 0
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'statusorder': statusorder,
//       'color': color,
//       'isdefault': isdefault,
//       'approve_status': approveStatus,
//       'super_status_id': superStatusId,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }

// class LeadUser {
//   final int id;
//   final int leadId;
//   final int userId;
//   final int isAccepted;
//   final String assignTime;
//   final String? lastActivityTime;
//   final String? deletedAt;

//   LeadUser({
//     required this.id,
//     required this.leadId,
//     required this.userId,
//     required this.isAccepted,
//     required this.assignTime,
//     this.lastActivityTime,
//     this.deletedAt,
//   });

//   factory LeadUser.fromJson(Map<String, dynamic> json) {
//     return LeadUser(
//       id: json['id'] as int,
//       leadId: json['lead_id'] as int,
//       userId: json['user_id'] as int,
//       isAccepted: json['isAccepted'] as int,
//       assignTime: json['assignTime'] as String,
//       lastActivityTime: json['lastActivityTime'] as String?,
//       deletedAt: json['deleted_at'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'lead_id': leadId,
//       'user_id': userId,
//       'isAccepted': isAccepted,
//       'assignTime': assignTime,
//       'lastActivityTime': lastActivityTime,
//       'deleted_at': deletedAt,
//     };
//   }
// }

// // Sources model
// class Sources {
//   final int id;
//   final String name;
//   final int status;
//   final String type;
//   final String startDate;
//   final String endDate;
//   final int compaignId;
//   final int isCroned;
//   final int runAllTime;
//   final String createdAt;
//   final String updatedAt;

//   Sources({
//     required this.id,
//     required this.name,
//     required this.status,
//     required this.type,
//     required this.startDate,
//     required this.endDate,
//     required this.compaignId,
//     required this.isCroned,
//     required this.runAllTime,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Sources.fromJson(Map<String, dynamic> json) {
//     return Sources(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       status: json['status'] as int,
//       type: json['type'] as String,
//       startDate: json['start_date'] as String,
//       endDate: json['end_date'] as String,
//       compaignId: json['compaign_id'] as int,
//       isCroned: json['is_croned'] as int,
//       runAllTime: json['run_all_time'] as int,
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'status': status,
//       'type': type,
//       'start_date': startDate,
//       'end_date': endDate,
//       'compaign_id': compaignId,
//       'is_croned': isCroned,
//       'run_all_time': runAllTime,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }

// class NewComment {
//   final int id;
//   final int leadId;
//   final int agentId;
//   final String? date;
//   final String? time;
//   final String? newComments;
//   final String? createdAt;
//   final String? updatedAt;

//   NewComment({
//     required this.id,
//     required this.leadId,
//     required this.agentId,
//     this.date,
//     this.time,
//     this.newComments,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory NewComment.fromJson(Map<String, dynamic> json) {
//     return NewComment(
//       id: json['id'] as int,
//       leadId: json['lead_id'] as int,
//       agentId: json['agent_id'] as int,
//       date: json['date'] as String?,
//       time: json['time'] as String?,
//       newComments: json['new_comments'] as String?,
//       createdAt: json['created_at'] as String?,
//       updatedAt: json['updated_at'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'lead_id': leadId,
//       'agent_id': agentId,
//       'date': date,
//       'time': time,
//       'new_comments': newComments,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }

// class Campaign {
//   final int id;
//   final int status;
//   final String name;
//   final String? secondaryName;
//   final String? isInternational;
//   final String createdAt;
//   final String updatedAt;

//   Campaign({
//     required this.id,
//     required this.status,
//     required this.name,
//     this.secondaryName,
//     this.isInternational,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Campaign.fromJson(Map<String, dynamic> json) {
//     return Campaign(
//       id: json['id'] as int,
//       status: json['status'] as int,
//       name: json['name'] as String,
//       secondaryName: json['secondary_name'] as String?,
//       isInternational: json['is_international'] as String?,
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'status': status,
//       'name': name,
//       'secondary_name': secondaryName,
//       'is_international': isInternational,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }
