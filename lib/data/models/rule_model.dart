class Rule{
  final String name;
  final int charge;
  String? id;
  final int policyTime;

  Rule({required this.name, required this.charge, this.id, required this.policyTime});

  factory Rule.fromJson(Map data){
    Rule rule = Rule(
      name: data['name'],
      charge: data['charge'],
      id: data['_id'],
      policyTime: data['policy_time'] ?? 0,
    );
    return rule;
  }

  Map toJson(){
    return {
      'name':name,
      'charge':charge,
      '_id': id,
      'policy_time': policyTime
    };
  }
}