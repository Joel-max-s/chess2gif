class FEN2Rep {

  List<List<List<String>>> getRepresentation(List<List<String>> fens) {
    
    List<List<List<String>>> boardRepresentations = List.empty(growable: true);

    for (var i = 0; i < fens[0].length; i++) {
      var fen = fens[0][i];
      var check = fens[1][i];
      fen = fen.replaceAll(new RegExp(r'\ .*'), '');
      var boardRepresentation = List.generate(
          8, (i) => List.generate(8, (index) => '', growable: false),
          growable: false);
      int counter = 0;
      for (var j = 0; j < 8; j++) {
        for (var k = 0; k < 8; k++) {
          int temp = getJumps(fen[counter]);
          if (fen[counter] == '/') {
            counter++;
            k--;
          } else if((fen[counter] == 'K' && check == 'C') || (fen[counter] == 'k' && check == 'c')) {
            String position = fen[counter];
            position += '+';
            boardRepresentation[j][k] = position;
            counter++;
          } else if (temp != 0) {
            k += temp - 1;
            counter++;
          } else {
            String position = fen[counter];
            boardRepresentation[j][k] = position;
            counter++;
          }
        }
        print(boardRepresentation[j].toString());
      }
      print('');
      boardRepresentations.add(boardRepresentation);
    }
    return boardRepresentations;
  }

  int getJumps(String givenFEN) {
    var number = int.tryParse(givenFEN);
    return number != null ? number.toInt() : 0;
  }
}
