enum PrintType{
  now,
  post,
  hand
}

class PrintOption{
  final String name;
  final PrintType type;

  PrintOption({required this.name, required this.type});
}