// leads_response.dart
class LeadsResponse {
  final int success;
  final String message;
  final int count;
  final LeadsData data;

  LeadsResponse({
    required this.success,
    required this.message,
    required this.count,
    required this.data,
  });

  factory LeadsResponse.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return LeadsResponse(
      success: _asInt(map['success']),
      message: _asString(map['message']),
      count: _asInt(map['count']),
      data: LeadsData.fromJson(_asMap(map['data'])),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'count': count,
    'data': data.toJson(),
  };
}

class LeadsData {
  final int currentPage;
  final List<Lead> data;
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

  LeadsData({
    required this.currentPage,
    required this.data,
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

  factory LeadsData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};

    final listRaw = map['data'];
    final list = (listRaw is List ? listRaw : const [])
        .map((e) => Lead.fromJson(_asMap(e)))
        .toList();

    return LeadsData(
      currentPage: _asInt(map['current_page']),
      data: list,
      firstPageUrl: _asString(map['first_page_url']),
      from: _asInt(map['from']),
      lastPage: _asInt(map['last_page']),
      lastPageUrl: _asString(map['last_page_url']),
      nextPageUrl: _asStringN(map['next_page_url']),
      path: _asString(map['path']),
      perPage: _asInt(map['per_page']),
      prevPageUrl: _asStringN(map['prev_page_url']),
      to: _asInt(map['to']),
      total: _asInt(map['total']),
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': data.map((x) => x.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

class Lead {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String date;
  final int status;
  final String statusName;
  final int compaign;
  final String campaignName;
  final String source;
  final String sourceName;
  final int agentId;
  final String agent;
  final int isFresh;

  Lead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.status,
    required this.statusName,
    required this.compaign,
    required this.campaignName,
    required this.source,
    required this.sourceName,
    required this.agentId,
    required this.agent,
    required this.isFresh,
  });

  factory Lead.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};

    return Lead(
      id: _asInt(map['id']),
      name: _asString(map['name']),
      email: _asString(map['email']),
      phone: _asString(map['phone']),
      date: _asString(map['date']),
      status: _asInt(map['status']),
      statusName: _asString(map['statusName']),
      compaign: _asInt(map['compaign']),
      campaignName: _asString(map['campaignName']),
      source: _asString(map['source']),
      sourceName: _asString(map['sourceName']),
      agentId: _asInt(map['agent_id']),
      agent: _asString(map['agent']),
      isFresh: _asInt(map['is_fresh']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'date': date,
    'status': status,
    'statusName': statusName,
    'compaign': compaign,
    'campaignName': campaignName,
    'source': source,
    'sourceName': sourceName,
    'agent_id': agentId,
    'agent': agent,
    'is_fresh': isFresh,
  };

  Lead copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? date,
    int? status,
    String? statusName,
    int? compaign,
    String? campaignName,
    String? source,
    String? sourceName,
    int? agentId,
    String? agent,
    int? isFresh,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      date: date ?? this.date,
      status: status ?? this.status,
      statusName: statusName ?? this.statusName,
      compaign: compaign ?? this.compaign,
      campaignName: campaignName ?? this.campaignName,
      source: source ?? this.source,
      sourceName: sourceName ?? this.sourceName,
      agentId: agentId ?? this.agentId,
      agent: agent ?? this.agent,
      isFresh: isFresh ?? this.isFresh,
    );
  }
}

int _asInt(dynamic v, {int def = 0}) {
  if (v == null) return def;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return def;
    return int.tryParse(s) ?? double.tryParse(s)?.toInt() ?? def;
  }
  return def;
}

String _asString(dynamic v, {String def = ''}) {
  if (v == null) return def;
  if (v is String) return v;
  return v.toString();
}

String? _asStringN(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

Map<String, dynamic> _asMap(dynamic v) {
  if (v is Map<String, dynamic>) return v;
  if (v is Map) {
    // coerce Map<dynamic, dynamic> to Map<String, dynamic>
    return v.map((k, val) => MapEntry(k.toString(), val));
  }
  return <String, dynamic>{};
}
