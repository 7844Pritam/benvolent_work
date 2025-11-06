class AgentsResponse {
  final int success;
  final String message;
  final List<AgentGroup> data;

  AgentsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AgentsResponse.fromJson(Map<String, dynamic> json) {
    final groups = <AgentGroup>[];
    if (json['data'] != null) {
      (json['data'] as Map<String, dynamic>).forEach((groupName, value) {
        if (value is Map<String, dynamic>) {
          groups.add(
            AgentGroup(
              groupName: groupName,
              agents: value.entries
                  .map(
                    (e) => Agent(
                      id: int.tryParse(e.key) ?? 0,
                      name: e.value.toString(),
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          // For "" : "All"
          groups.add(
            AgentGroup(
              groupName: groupName,
              agents: [Agent(id: 0, name: value.toString())],
            ),
          );
        }
      });
    }
    return AgentsResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: groups,
    );
  }
}

class AgentGroup {
  final String groupName;
  final List<Agent> agents;

  AgentGroup({required this.groupName, required this.agents});
}

class Agent {
  final int id;
  final String name;

  Agent({required this.id, required this.name});
}
