/**
 * generate from the FENs the internal Boardrepresentation
 */
class FEN2Rep {
  //activates logentries
  bool logIsActive;

  FEN2Rep(bool log) {
    logIsActive = log;
  }
  /**
   * generate from the FENs the internal Boardrepresentation
   */
  List<List<List<String>>> getRepresentation(List<List<String>> fens) {
    //the internal Game-representation
    List<List<List<String>>> boardRepresentations = List.empty(growable: true);

    //loop through all fens
    for (var i = 0; i < fens[0].length; i++) {
      //the fen
      var fen = fens[0][i];
      //the extra information for the fen
      var moreInfo = fens[1][i];
      //delete unnessecary information
      fen = fen.replaceAll(new RegExp(r'\ .*'), '');
      //make an empty board
      var boardRepresentation = List.generate(
          8, (i) => List.generate(8, (index) => '', growable: false),
          growable: false);
      int counter = 0;
      //check if en passant happend
      int enpassentSquare = -1;
      if (moreInfo.length > 1) {
        enpassentSquare = getNumber(moreInfo.substring(1));
      }

      //loop through the board
      for (var j = 0; j < 8; j++) {
        for (var k = 0; k < 8; k++) {
          //get the jumps from the number from the FEN
          int temp = getNumber(fen[counter]);
          //if linebreak
          if (fen[counter] == '/') {
            counter++;
            k--;
          }
          //if jumps from FEN
          else if (temp != 0) {
            k += temp - 1;
            counter++;
          }
          //if we are at the King and a check is noticed
          else if ((fen[counter] == 'K' && moreInfo.contains('C')) ||
              (fen[counter] == 'k' && moreInfo.contains('c'))) {
            String position = fen[counter];
            position += '+';
            boardRepresentation[j][k] = position;
            counter++;
          }
          //if short kingside castle for black
          else if ((j == 0 && k > 4) && moreInfo == 's') {
            String position = fen[counter];
            position += 's';
            boardRepresentation[j][k] = position;
            counter++;
          }
          //if short kingside castle for white
          else if ((j == 7 && k > 4) && moreInfo == 'S') {
            String position = fen[counter];
            position += 'S';
            boardRepresentation[j][k] = position;
            counter++;
          }
          //if long queenside castle for black
          else if ((j == 0 && k < 5) && moreInfo == 'l') {
            String position = fen[counter];
            position += 'l';
            boardRepresentation[j][k] = position;
            counter++;
          }
          //if long queenside castle for white
          else if ((j == 7 && k < 5) && moreInfo == 'L') {
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
      }

      //if en passant happend
      if (enpassentSquare != -1) {
        //en passant, white takes black pawn
        if (enpassentSquare < 48) {
          int row = enpassentSquare ~/ 16 + 1;
          int column = enpassentSquare % 16;
          boardRepresentation[row][column] = "-";
        }
        //en passant, black takes white pawn
        else if (enpassentSquare >= 80) {
          int row = enpassentSquare ~/ 16 - 1;
          int column = enpassentSquare % 16;
          boardRepresentation[row][column] = "-";
        }
      }

      //print the board representation
      if (logIsActive) {
        for (var rep in boardRepresentation) {
          print(rep.toString());
        }
        print('');
      }
      boardRepresentations.add(boardRepresentation);
    }
    return boardRepresentations;
  }

  /**
   * parse a string and return a number if the string is a 'sting-int'
   */
  int getNumber(String givenFEN) {
    var number = int.tryParse(givenFEN);
    return number != null ? number.toInt() : 0;
  }
}
