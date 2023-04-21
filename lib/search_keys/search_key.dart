List<String> addSearchKeys({required String searchName}) {
  List<String> indexList = [];
  List<String> splitText = searchName.split(" ");
  for (int i = 0; i < splitText.length; i++) {
    for (int j = 0; j < splitText[i].length + 1; j++) {
      indexList.add(splitText[i].substring(0, j).toLowerCase());
    }
  }
  return indexList;
}