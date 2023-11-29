class Rule{
  final String name;
  final int charge;
  final String id;

  Rule({required this.name, required this.charge, required this.id});

  factory Rule.fromJson(Map data){
    Rule rule = Rule(
      name: data['name'],
      charge: data['charge'],
      id: data['_id'],
    );
    return rule;
  }
}