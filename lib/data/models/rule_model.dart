class Rule{
  final String name;
  final int charge;
  final String id;
  final int timePolicy;

  Rule({required this.name, required this.charge, required this.id, required this.timePolicy});

  factory Rule.fromJson(Map data){
    Rule rule = Rule(
      name: data['name'],
      charge: data['charge'],
      id: data['_id'],
      timePolicy: data['time_policy'] ?? 0,
    );
    return rule;
  }
}