class BuildHeaders{
  Map<String,String> headers = {};
  BuildHeaders();

  BuildHeaders supportJson(){
    headers.addAll({
      'Content-Type': 'application/json; charset=utf-8'
    });
    return this;
  }

  BuildHeaders add(String key, String value){
    headers.addAll({
      key: value
    });
    return this;
  }

  Map<String,String> finish(){
    return headers;
  }
}