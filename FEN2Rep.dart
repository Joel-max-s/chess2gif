class FEN2Rep {

  List<List<List<String>>> getRepresentation(List<List<String>> fens) {
    
    List<List<List<String>>> boardRepresentations = List.empty(growable: true);

    for (var i = 0; i < fens[0].length; i++) {
      var fen = fens[0][i];
      //print(fen);
      var moreInfo = fens[1][i];
      fen = fen.replaceAll(new RegExp(r'\ .*'), '');
      //print(fen);
      //print(fen.length);
      var boardRepresentation = List.generate(
          8, (i) => List.generate(8, (index) => '', growable: false),
          growable: false);
      int counter = 0;
      //TODO: enpassant (aus epsquare ausrechnen welcher blank sein muss)

      int enpassentSquare = -1;
      if(moreInfo.length > 1)
        enpassentSquare = getNumber(moreInfo.substring(1));
      for (var j = 0; j < 8; j++) {
        for (var k = 0; k < 8; k++) {
          int temp = getNumber(fen[counter]);
          if (fen[counter] == '/') {
            counter++;
            k--;
          } else if (temp != 0) {
            k += temp - 1;
            counter++;
          } else if((fen[counter] == 'K' && moreInfo.contains('C')) || (fen[counter] == 'k' && moreInfo.contains('c'))) {
            String position = fen[counter];
            position += '+';
            boardRepresentation[j][k] = position;
            counter++;
          } else if((j == 0 && k > 4) && moreInfo == 's') {
            String position = fen[counter];
            position += 's';
            boardRepresentation[j][k] = position;
            counter++;
          } else if((j == 7 && k > 4) && moreInfo == 'S') {
            String position = fen[counter];
            position += 'S';
            boardRepresentation[j][k] = position;
            counter++;
          } else if((j == 0 && k < 5) && moreInfo == 'l') {
            String position = fen[counter];
            position += 'l';
            boardRepresentation[j][k] = position;
            counter++;
          } else if((j == 7 && k < 5) && moreInfo == 'L') {
            String position = fen[counter];
            position += 'L';
            boardRepresentation[j][k] = position;
            counter++;
          } else {
            String position = fen[counter];
            boardRepresentation[j][k] = position;
            counter++;
          }
        }
        //print(boardRepresentation[j].toString());
      }
      //print('');
      if(enpassentSquare != -1)
        //TODO: feld mit markierung versehen das sich nichts ändert wegen enpassanttake
      boardRepresentations.add(boardRepresentation);
    }
    return boardRepresentations;
  }

  int getNumber(String givenFEN) {
    var number = int.tryParse(givenFEN);
    return number != null ? number.toInt() : 0;
  }
}
