final List<String> rules = [
  '1- x',
  '2- x',
  '10- x',
  '13- x',
  '22- x',
  '17- x',
  '20- x',
  '9- x',
];

void main(){
  rules.sort(
    (a, b){
          var partsA = a.split('-');
          var numberA = int.parse(partsA[0]);
          var partsB = b.split('-');
          var numberB = int.parse(partsB[0]);

          return numberA - numberB;
    }
  );
  print(rules);
}