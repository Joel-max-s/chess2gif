class FEN2Rep {

  List<List<List<String>>> getRepresentation(List<String> FENs) {
    List<List<List<String>>> boardRepresentations = List.empty(growable: true);

    for (var FEN in FENs) {
      FEN = FEN.replaceAll(new RegExp(r'\ .*'), '');
      var boardRepresentation = List.generate(
          8, (i) => List.generate(8, (index) => '', growable: false),
          growable: false);
      int counter = 0;
      for (var i = 0; i < 8; i++) {
        for (var j = 0; j < 8; j++) {
          int temp = getJumps(FEN, counter);
          if (FEN[counter] == '/') {
            counter++;
            j--;
          } else if (temp != 0) {
            j += temp - 1;
            counter++;
          } else {
            String position = FEN[counter];
            boardRepresentation[i][j] = position;
            counter++;
          }
        }
        print(boardRepresentation[i].toString());
      }
      print('');
      boardRepresentations.add(boardRepresentation);
    }
    return boardRepresentations;
  }

  int getJumps(String givenFEN, int position) {
    var character = givenFEN[position];
    var number = int.tryParse(character);
    return number != null ? number.toInt() : 0;
  }
}
