// lead_details_models.dart

import 'package:intl/intl.dart';

class LeadDetailsResponse {
  final int success;
  final String message;
  final List<LeadAssignment> data;

  LeadDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeadDetailsResponse.fromJson(Map<String, dynamic> json) {
    return LeadDetailsResponse(
      success: _asInt(json['success']) ?? 0,
      message: (json['message'] ?? '').toString(),
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => LeadAssignment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class LeadAssignment {
  final int? id;
  final int? leadId;
  final int? userId;
  final int? isAccepted; // 0/1
  final DateTime? assignTime;
  final DateTime? lastActivityTime;
  final DateTime? deletedAt;
  final Lead lead;

  LeadAssignment({
    required this.id,
    required this.leadId,
    required this.userId,
    required this.isAccepted,
    required this.assignTime,
    required this.lastActivityTime,
    required this.deletedAt,
    required this.lead,
  });

  factory LeadAssignment.fromJson(Map<String, dynamic> json) {
    return LeadAssignment(
      id: _asInt(json['id']),
      leadId: _asInt(json['lead_id']),
      userId: _asInt(json['user_id']),
      isAccepted: _asInt(json['isAccepted']),
      assignTime: _asDate(json['assignTime']),
      lastActivityTime: _asDate(json['lastActivityTime']),
      deletedAt: _asDate(json['deleted_at']),
      lead: Lead.fromJson(json['lead'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lead_id': leadId,
    'user_id': userId,
    'isAccepted': isAccepted,
    'assignTime': assignTime?.toIso8601String(),
    'lastActivityTime': lastActivityTime?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'lead': lead.toJson(),
  };
}

class Lead {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? altPhone;
  final String? additionalPhone;

  final DateTime? date;
  final DateTime? dob;

  final int? sourceId; // parsed from "source": "7"
  final String? priority;
  final String? comment;
  final String? additionalComment;

  final int? customerId;
  final int? developerId;
  final int? propertyId;

  final String? propertyPreference;
  final String? jobProfile;
  final String? avgIncome; // keep money as string
  final int? statusId;
  final String? propertyType;
  final String? leadMarket;
  final String? propertyRef;
  final String? sourcePortal;
  final int? subStatusId;
  final String? attachment;
  final String? type;
  final String? subType;
  final String? amount; // keep money as string
  final DateTime? closedDate;
  final int? closeBy;
  final String? externalLeadId; // "lead_id": "LE_Aug_01_2025"
  final int? agentId;
  final String? review;
  final int? createdBy;
  final int? assignLeadsCount;
  final String? previousAgentIds;
  final int? isAccepted; // 0/1
  final DateTime? confirmDate;
  final int? cronCount;
  final int? activityCheck;
  final int? compaignId; // spelled like in API
  final int? subSourceId;
  final int? compaignManagerId;
  final int? eventId;
  final int? superStatusId;
  final int? usedForPromotion; // 0/1
  final int? noAnswerStatusCount;
  final int? needWhatsapp; // 0/1
  final int? isFresh; // 0/1

  final Property? property;
  final List<Agent> agents;
  final StatusInfo? statuses;
  final LeadUserLink? leadUser;
  final SourceInfo? sources;
  final List<CommentEntry> newComments;
  final CampaignInfo? campaign;

  Lead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.altPhone,
    required this.additionalPhone,
    required this.date,
    required this.dob,
    required this.sourceId,
    required this.priority,
    required this.comment,
    required this.additionalComment,
    required this.customerId,
    required this.developerId,
    required this.propertyId,
    required this.propertyPreference,
    required this.jobProfile,
    required this.avgIncome,
    required this.statusId,
    required this.propertyType,
    required this.leadMarket,
    required this.propertyRef,
    required this.sourcePortal,
    required this.subStatusId,
    required this.attachment,
    required this.type,
    required this.subType,
    required this.amount,
    required this.closedDate,
    required this.closeBy,
    required this.externalLeadId,
    required this.agentId,
    required this.review,
    required this.createdBy,
    required this.assignLeadsCount,
    required this.previousAgentIds,
    required this.isAccepted,
    required this.confirmDate,
    required this.cronCount,
    required this.activityCheck,
    required this.compaignId,
    required this.subSourceId,
    required this.compaignManagerId,
    required this.eventId,
    required this.superStatusId,
    required this.usedForPromotion,
    required this.noAnswerStatusCount,
    required this.needWhatsapp,
    required this.isFresh,
    required this.property,
    required this.agents,
    required this.statuses,
    required this.leadUser,
    required this.sources,
    required this.newComments,
    required this.campaign,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: _asInt(json['id']),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      altPhone: (json['alt_phone'] ?? '').toString(),
      additionalPhone: json['additional_phone']?.toString(),
      date: _asDate(json['date']),
      dob: _asDate(json['dob']),
      sourceId: _asInt(json['source']),
      priority: json['priority']?.toString(),
      comment: json['comment']?.toString(),
      additionalComment: json['additional_comment']?.toString(),
      customerId: _asInt(json['customer_id']),
      developerId: _asInt(json['developer_id']),
      propertyId: _asInt(json['property_id']),
      propertyPreference: json['property_preference']?.toString(),
      jobProfile: json['job_profile']?.toString(),
      avgIncome: json['avg_income']?.toString(),
      statusId: _asInt(json['status']),
      propertyType: json['property_type']?.toString(),
      leadMarket: json['lead_market']?.toString(),
      propertyRef: json['property_ref']?.toString(),
      sourcePortal: json['source_portal']?.toString(),
      subStatusId: _asInt(json['sub_status']),
      attachment: json['attachment']?.toString(),
      type: json['type']?.toString(),
      subType: json['sub_type']?.toString(),
      amount: json['amount']?.toString(),
      closedDate: _asDate(json['closed_date']),
      closeBy: _asInt(json['close_by']),
      externalLeadId: json['lead_id']?.toString(),
      agentId: _asInt(json['agent_id']),
      review: json['review']?.toString(),
      createdBy: _asInt(json['created_by']),
      assignLeadsCount: _asInt(json['assign_leads_count']) ?? 0,
      previousAgentIds: json['previous_agent_ids']?.toString(),
      isAccepted: _asInt(json['is_accepted']),
      confirmDate: _asDate(json['confirm_date']),
      cronCount: _asInt(json['cron_count']),
      activityCheck: _asInt(json['activityCheck']),
      compaignId: _asInt(json['compaign_id']),
      subSourceId: _asInt(json['sub_source_id']),
      compaignManagerId: _asInt(json['compaign_manager_id']),
      eventId: _asInt(json['event_id']),
      superStatusId: _asInt(json['super_status_id']),
      usedForPromotion: _asInt(json['used_for_promotion']),
      noAnswerStatusCount: _asInt(json['no_answer_status_count']),
      needWhatsapp: _asInt(json['need_whatsapp']),
      isFresh: _asInt(json['is_fresh']),
      property: json['property'] is Map<String, dynamic>
          ? Property.fromJson(json['property'])
          : null,
      agents: (json['agents'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Agent.fromJson(e))
          .toList(),
      statuses: json['statuses'] is Map<String, dynamic>
          ? StatusInfo.fromJson(json['statuses'])
          : null,
      leadUser: json['lead_user'] is Map<String, dynamic>
          ? LeadUserLink.fromJson(json['lead_user'])
          : null,
      sources: json['sources'] is Map<String, dynamic>
          ? SourceInfo.fromJson(json['sources'])
          : null,
      newComments: (json['new_comments'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => CommentEntry.fromJson(e))
          .toList(),
      campaign: json['campaign'] is Map<String, dynamic>
          ? CampaignInfo.fromJson(json['campaign'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'alt_phone': altPhone,
    'additional_phone': additionalPhone,
    'date': date?.toIso8601String(),
    'dob': dob?.toIso8601String(),
    'source': sourceId,
    'priority': priority,
    'comment': comment,
    'additional_comment': additionalComment,
    'customer_id': customerId,
    'developer_id': developerId,
    'property_id': propertyId,
    'property_preference': propertyPreference,
    'job_profile': jobProfile,
    'avg_income': avgIncome,
    'status': statusId,
    'property_type': propertyType,
    'lead_market': leadMarket,
    'property_ref': propertyRef,
    'source_portal': sourcePortal,
    'sub_status': subStatusId,
    'attachment': attachment,
    'type': type,
    'sub_type': subType,
    'amount': amount,
    'closed_date': closedDate?.toIso8601String(),
    'close_by': closeBy,
    'lead_id': externalLeadId,
    'agent_id': agentId,
    'review': review,
    'created_by': createdBy,
    'assign_leads_count': assignLeadsCount,
    'previous_agent_ids': previousAgentIds,
    'is_accepted': isAccepted,
    'confirm_date': confirmDate?.toIso8601String(),
    'cron_count': cronCount,
    'activityCheck': activityCheck,
    'compaign_id': compaignId,
    'sub_source_id': subSourceId,
    'compaign_manager_id': compaignManagerId,
    'event_id': eventId,
    'super_status_id': superStatusId,
    'used_for_promotion': usedForPromotion,
    'no_answer_status_count': noAnswerStatusCount,
    'need_whatsapp': needWhatsapp,
    'is_fresh': isFresh,
    'property': property?.toJson(),
    'agents': agents.map((e) => e.toJson()).toList(),
    'statuses': statuses?.toJson(),
    'lead_user': leadUser?.toJson(),
    'sources': sources?.toJson(),
    'new_comments': newComments.map((e) => e.toJson()).toList(),
    'campaign': campaign?.toJson(),
  };
}

class Property {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final int? cityId;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? meta;
  final String? source;
  final int? developerId;
  final String? status;
  final String? budget; // keep as string
  final String? image;
  final String? featuredProperty;
  final String? brochure;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> amenities; // spelled "ameneties" in API

  Property({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.cityId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.meta,
    required this.source,
    required this.developerId,
    required this.status,
    required this.budget,
    required this.image,
    required this.featuredProperty,
    required this.brochure,
    required this.createdAt,
    required this.updatedAt,
    required this.amenities,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: _asInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      cityId: _asInt(json['city_id']),
      address: json['address']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      meta: json['meta']?.toString(),
      source: json['source']?.toString(),
      developerId: _asInt(json['developer_id']),
      status: json['status']?.toString(),
      budget: json['budget']?.toString(),
      image: json['image']?.toString(),
      featuredProperty: json['featured_property']?.toString(),
      brochure: json['brochure']?.toString(),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
      amenities: (json['ameneties'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'city_id': cityId,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'meta': meta,
    'source': source,
    'developer_id': developerId,
    'status': status,
    'budget': budget,
    'image': image,
    'featured_property': featuredProperty,
    'brochure': brochure,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'ameneties': amenities,
  };
}

class Agent {
  final int? id;
  final int? designationId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final dynamic dob; // unknown format in sample
  final int? phone;
  final int? reportingPerson;
  final String? atContact;
  final String? address;
  final String? userProfile;
  final String? status;
  final String? availability;
  final String? deviceId;
  final int? isExcluded;
  final int? permissionMenu;
  final int? permissionForCl;
  final int? permissionForSecondaryLeads;
  final String? dataOfJoining;
  final String? bloodGroup;
  final String? emergencyContactNumber;
  final String? emergencyContactName;
  final String? emergencyContactRelationship;
  final String? addressInUae;
  final String? nationality;
  final String? medicalConditions;
  final String? maritalStatus;
  final String? visaType;
  final String? educationDetails;
  final int? companyId;
  final int? isTesting;
  final String? employeeId;
  final String? department;
  final int? isDisplayWebsite;
  final String? orderBy;
  final int? createdBy;
  final DateTime? createdAt;
  final int? leadExportPermission;
  final int? leadExportEmailMask;
  final int? leadExportPhoneMask;
  final String? fullName;
  final AgentPivot? pivot;
  final AgentMetaData? metaData;

  Agent({
    required this.id,
    required this.designationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
    required this.phone,
    required this.reportingPerson,
    required this.atContact,
    required this.address,
    required this.userProfile,
    required this.status,
    required this.availability,
    required this.deviceId,
    required this.isExcluded,
    required this.permissionMenu,
    required this.permissionForCl,
    required this.permissionForSecondaryLeads,
    required this.dataOfJoining,
    required this.bloodGroup,
    required this.emergencyContactNumber,
    required this.emergencyContactName,
    required this.emergencyContactRelationship,
    required this.addressInUae,
    required this.nationality,
    required this.medicalConditions,
    required this.maritalStatus,
    required this.visaType,
    required this.educationDetails,
    required this.companyId,
    required this.isTesting,
    required this.employeeId,
    required this.department,
    required this.isDisplayWebsite,
    required this.orderBy,
    required this.createdBy,
    required this.createdAt,
    required this.leadExportPermission,
    required this.leadExportEmailMask,
    required this.leadExportPhoneMask,
    required this.fullName,
    required this.pivot,
    required this.metaData,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: _asInt(json['id']),
      designationId: _asInt(json['designation_id']),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString(),
      dob: json['dob'],
      phone: _asInt(json['phone']),
      reportingPerson: _asInt(json['reporting_person']),
      atContact: json['at_contact']?.toString(),
      address: json['address']?.toString(),
      userProfile: json['user_profile']?.toString(),
      status: json['status']?.toString(),
      availability: json['availability']?.toString(),
      deviceId: json['device_id']?.toString(),
      isExcluded: _asInt(json['is_excluded']),
      permissionMenu: _asInt(json['permission_menu']),
      permissionForCl: _asInt(json['permission_for_cl']),
      permissionForSecondaryLeads: _asInt(
        json['permission_for_secondaryLeads'],
      ),
      dataOfJoining: json['data_of_joining']?.toString(),
      bloodGroup: json['blood_group']?.toString(),
      emergencyContactNumber: json['emergency_contact_number']?.toString(),
      emergencyContactName: json['emergency_contact_name']?.toString(),
      emergencyContactRelationship: json['emergency_contact_relationship']
          ?.toString(),
      addressInUae: json['address_in_uae']?.toString(),
      nationality: json['nationality']?.toString(),
      medicalConditions: json['medical_conditions']?.toString(),
      maritalStatus: json['marital_status']?.toString(),
      visaType: json['visa_type']?.toString(),
      educationDetails: json['education_details']?.toString(),
      companyId: _asInt(json['company_id']),
      isTesting: _asInt(json['is_testing']),
      employeeId: json['employeeId']?.toString(),
      department: json['department']?.toString(),
      isDisplayWebsite: _asInt(json['is_display_website']),
      orderBy: json['orderBy']?.toString(),
      createdBy: _asInt(json['created_by']),
      createdAt: _asDate(json['created_at']),
      leadExportPermission: _asInt(json['lead_export_permission']),
      leadExportEmailMask: _asInt(json['lead_export_email_mask']),
      leadExportPhoneMask: _asInt(json['lead_export_phone_mask']),
      fullName: json['full_name']?.toString(),
      pivot: json['pivot'] is Map<String, dynamic>
          ? AgentPivot.fromJson(json['pivot'])
          : null,
      metaData: json['meta_data'] is Map<String, dynamic>
          ? AgentMetaData.fromJson(json['meta_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
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
    'created_at': createdAt?.toIso8601String(),
    'lead_export_permission': leadExportPermission,
    'lead_export_email_mask': leadExportEmailMask,
    'lead_export_phone_mask': leadExportPhoneMask,
    'full_name': fullName,
    'pivot': pivot?.toJson(),
    'meta_data': metaData?.toJson(),
  };
}

class AgentPivot {
  final int? leadId;
  final int? userId;
  final DateTime? deletedAt;
  final int? isAccepted;
  final DateTime? assignTime;
  final DateTime? lastActivityTime;

  AgentPivot({
    required this.leadId,
    required this.userId,
    required this.deletedAt,
    required this.isAccepted,
    required this.assignTime,
    required this.lastActivityTime,
  });

  factory AgentPivot.fromJson(Map<String, dynamic> json) {
    return AgentPivot(
      leadId: _asInt(json['lead_id']),
      userId: _asInt(json['user_id']),
      deletedAt: _asDate(json['deleted_at']),
      isAccepted: _asInt(json['isAccepted']),
      assignTime: _asDate(json['assignTime']),
      lastActivityTime: _asDate(json['lastActivityTime']),
    );
  }

  Map<String, dynamic> toJson() => {
    'lead_id': leadId,
    'user_id': userId,
    'deleted_at': deletedAt?.toIso8601String(),
    'isAccepted': isAccepted,
    'assignTime': assignTime?.toIso8601String(),
    'lastActivityTime': lastActivityTime?.toIso8601String(),
  };
}

class AgentMetaData {
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

  AgentMetaData({
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

  factory AgentMetaData.fromJson(Map<String, dynamic> json) {
    return AgentMetaData(
      indianNumber: json['indian_number']?.toString(),
      dob: json['dob']?.toString(),
      bloodGroup: json['blood_group']?.toString(),
      personalEmail: json['personal_email']?.toString(),
      emergencyNumber: json['emergency_number']?.toString(),
      passportNumber: json['passport_number']?.toString(),
      passportExpiryDate: json['passport_expiry_date']?.toString(),
      visaNumber: json['visa_number']?.toString(),
      visaExpiryDate: json['visa_expiry_date']?.toString(),
      bankName: json['bank_name']?.toString(),
      bankIfsc: json['bank_ifsc']?.toString(),
      accountNumber: json['account_number']?.toString(),
      addressInUae: json['address_in_uae']?.toString(),
      emergencyContactName: json['emergency_contact_name']?.toString(),
      emergencyContactRelationship: json['emergency_contact_relationship']
          ?.toString(),
      nationality: json['nationality']?.toString(),
      medicalConditions: json['medical_conditions']?.toString(),
      maritalStatus: json['marital_status']?.toString(),
      visaType: json['visa_type']?.toString(),
      educationDetails: json['education_details']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
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

class StatusInfo {
  final int? id;
  final String? name;
  final int? statusOrder;
  final String? color;
  final int? isDefault;
  final String? approveStatus;
  final int? superStatusId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StatusInfo({
    required this.id,
    required this.name,
    required this.statusOrder,
    required this.color,
    required this.isDefault,
    required this.approveStatus,
    required this.superStatusId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StatusInfo.fromJson(Map<String, dynamic> json) {
    return StatusInfo(
      id: _asInt(json['id']),
      name: json['name']?.toString(),
      statusOrder: _asInt(json['statusorder']),
      color: json['color']?.toString(),
      isDefault: _asInt(json['isdefault']),
      approveStatus: json['approve_status']?.toString(),
      superStatusId: _asInt(json['super_status_id']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'statusorder': statusOrder,
    'color': color,
    'isdefault': isDefault,
    'approve_status': approveStatus,
    'super_status_id': superStatusId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class LeadUserLink {
  final int? id;
  final int? leadId;
  final int? userId;
  final int? isAccepted;
  final DateTime? assignTime;
  final DateTime? lastActivityTime;
  final DateTime? deletedAt;

  LeadUserLink({
    required this.id,
    required this.leadId,
    required this.userId,
    required this.isAccepted,
    required this.assignTime,
    required this.lastActivityTime,
    required this.deletedAt,
  });

  factory LeadUserLink.fromJson(Map<String, dynamic> json) {
    return LeadUserLink(
      id: _asInt(json['id']),
      leadId: _asInt(json['lead_id']),
      userId: _asInt(json['user_id']),
      isAccepted: _asInt(json['isAccepted']),
      assignTime: _asDate(json['assignTime']),
      lastActivityTime: _asDate(json['lastActivityTime']),
      deletedAt: _asDate(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lead_id': leadId,
    'user_id': userId,
    'isAccepted': isAccepted,
    'assignTime': assignTime?.toIso8601String(),
    'lastActivityTime': lastActivityTime?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };
}

class SourceInfo {
  final int? id;
  final String? name;
  final int? status;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? compaignId;
  final int? isCroned;
  final int? runAllTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SourceInfo({
    required this.id,
    required this.name,
    required this.status,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.compaignId,
    required this.isCroned,
    required this.runAllTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SourceInfo.fromJson(Map<String, dynamic> json) {
    return SourceInfo(
      id: _asInt(json['id']),
      name: json['name']?.toString(),
      status: _asInt(json['status']),
      type: json['type']?.toString(),
      startDate: _asDate(json['start_date']),
      endDate: _asDate(json['end_date']),
      compaignId: _asInt(json['compaign_id']),
      isCroned: _asInt(json['is_croned']),
      runAllTime: _asInt(json['run_all_time']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'type': type,
    'start_date': startDate?.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'compaign_id': compaignId,
    'is_croned': isCroned,
    'run_all_time': runAllTime,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class CommentEntry {
  final int? id;
  final int? leadId;
  final int? agentId;

  /// Calendar date for the note (e.g. '2025-08-01')
  final DateTime? date;

  /// Time string as provided by API (e.g. '13:28:46')
  final String? time;

  /// The actual note text (maps from `new_comments` in API; falls back to `text`/`comment`/`message`)
  final String? text;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommentEntry({
    this.id,
    this.leadId,
    this.agentId,
    this.date,
    this.time,
    this.text,
    this.createdAt,
    this.updatedAt,
  });

  factory CommentEntry.fromJson(Map<String, dynamic> json) {
    return CommentEntry(
      id: _asInt(json['id']),
      leadId: _asInt(json['lead_id']),
      agentId: _asInt(json['agent_id']),
      date: _asDate(json['date']),
      time: _asString(json['time']),
      // Prefer `new_comments`, but accept other common keys if backend changes
      text: _asNonEmptyString(
        json['new_comments'] ??
            json['text'] ??
            json['comment'] ??
            json['message'],
      ),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lead_id': leadId,
      'agent_id': agentId,
      // API usually expects plain date string; keep created/updated as ISO
      'date': date == null ? null : DateFormat('yyyy-MM-dd').format(date!),
      'time': time,
      'new_comments': text,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // ------- helpers -------

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return int.tryParse(s);
  }

  static String? _asString(dynamic v) {
    if (v == null) return null;
    return v.toString();
  }

  static String? _asNonEmptyString(dynamic v) {
    final s = _asString(v);
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }

  static DateTime? _asDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;

    final s = v.toString().trim();
    if (s.isEmpty) return null;

    try {
      return DateTime.parse(s);
    } catch (_) {}

    // Try common backend formats
    for (final fmt in [
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('dd-MM-yyyy'),
    ]) {
      try {
        return fmt.parseStrict(s);
      } catch (_) {}
    }
    return null;
  }
}

class CampaignInfo {
  final int? id;
  final int? status;
  final String? name;
  final String? secondaryName;
  final dynamic isInternational;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CampaignInfo({
    required this.id,
    required this.status,
    required this.name,
    required this.secondaryName,
    required this.isInternational,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampaignInfo.fromJson(Map<String, dynamic> json) {
    return CampaignInfo(
      id: _asInt(json['id']),
      status: _asInt(json['status']),
      name: json['name']?.toString(),
      secondaryName: json['secondary_name']?.toString(),
      isInternational: json['is_international'],
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'name': name,
    'secondary_name': secondaryName,
    'is_international': isInternational,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

/// ------------------------
/// Helpers
/// ------------------------

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  if (s.isEmpty) return null;
  // Tolerate "YYYY-MM-DD HH:mm:ss" and ISO strings
  final isoish = s.contains(' ') ? s.replaceFirst(' ', 'T') : s;
  return DateTime.tryParse(isoish);
}
