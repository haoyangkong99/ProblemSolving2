class DataPassingService {
  Map<String, dynamic> dataPassed = {};

  void addToDataPassingList(String field, Object data) {
    Map<String, Object> temp = {field: data};
    if (dataPassed == null) {
      dataPassed = {};
    }
    dataPassed.addAll(temp);
  }

  Object? get(String field) {
    return dataPassed[field];
  }

  void removeField(String field) {
    dataPassed.remove(field);
  }

  bool checkField(String field) {
    return dataPassed.containsKey(field);
  }

  void removeAllData() {
    dataPassed.clear();
  }
}
