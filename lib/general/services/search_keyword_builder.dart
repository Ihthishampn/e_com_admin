List<String> keywordsBuilder(String caseNumber) {
  List<String> caseSearchList = <String>[];
  String temp = "";

  List<String> nameSplits = caseNumber.split(" ");
  for (int i = 0; i < nameSplits.length; i++) {
    String name = "";

    for (int k = i; k < nameSplits.length; k++) {
      name = "$name${nameSplits[k]} ";
    }
    temp = "";

    for (int j = 0; j < name.length; j++) {
      temp = temp + name[j];
      caseSearchList.add(temp
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
          .replaceAll(" ", ""));
    }
  }
  caseSearchList.removeWhere(
    (element) => element == '',
  );
  return caseSearchList.toSet().toList();
}
