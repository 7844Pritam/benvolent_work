class AgentsResponse {
  final int success;
  final String message;
  final Map<String, dynamic> data;

  AgentsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AgentsResponse.fromJson(Map<String, dynamic> json) {
    return AgentsResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class GroupedAgentsResponse {
  final int success;
  final String message;
  final String allLabel;
  final List<AgentGroup> groups;

  GroupedAgentsResponse({
    required this.success,
    required this.message,
    required this.allLabel,
    required this.groups,
  });

  factory GroupedAgentsResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'];
    final String allLabel = data[''] ?? 'All';

    final List<AgentGroup> groups = [];
    data.forEach((key, value) {
      if (key.isNotEmpty && value is Map<String, dynamic>) {
        groups.add(
          AgentGroup(groupName: key, agents: Map<String, String>.from(value)),
        );
      }
    });

    return GroupedAgentsResponse(
      success: json['success'],
      message: json['message'],
      allLabel: allLabel,
      groups: groups,
    );
  }
}

class AgentGroup {
  final String groupName;
  final Map<String, String> agents;

  AgentGroup({required this.groupName, required this.agents});
}
