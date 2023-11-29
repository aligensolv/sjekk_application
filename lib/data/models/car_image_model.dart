class CarImage{
  final String path;

  CarImage({required this.path});

  factory CarImage.fromString(String path){
    print('incar');
    return CarImage(path: path);
  }

  Map toJson(){
    return {
      'path': path
    };
  }
}