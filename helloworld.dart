import 'svgSamples.dart';

void main(List<String> args) {

  var testClass = new svgSamples();
  testClass.makeBoard();

  var testFEN = 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2';
  var other = '8/8/8/2k5/4K3/8/8/8';

  //delete everything after the first whitespace
  testFEN = testFEN.replaceAll(new RegExp(r'\ .*'), '');
  print(testFEN);
  var boardReprensentation = List.generate(8, (i) => List.generate(8, (index) => '', growable: false), growable: false);

  var FENlength = testFEN.length;

  print(FENlength);

  int counter = 0;

  for(var i = 0; i < 8; i++) {
    for(var j = 0; j < 8; j++) {
      int temp = getJumps(testFEN, counter);
      if(testFEN[counter] == '/') {
        counter++;
        j--;
      }
      else if(temp != 0) {
        j+= temp - 1;
        counter++;
      }
      else {
        String position = testFEN[counter];
        boardReprensentation[i][j] = position;
        testClass.placePiece(position, j, i);
        counter++;
      }
    }
    print(boardReprensentation[i].toString());
  }

  testClass.makeSVG();
}

int getJumps(String givenFEN, int position) {

  var character = givenFEN[position];

  var number = int.tryParse(character);

  return number != null ? number.toInt() : 0;
}