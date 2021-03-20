import 'PGNParser.dart';
import 'FEN2Rep.dart';
import 'Rep2GIF.dart';

void main(List<String> args) {
  //parse the PGN file
  PGNParser parser = new PGNParser();
  List<List<List<String>>> FENs = parser.parsePGN();

  int counter = 0;
  //for every game in the pgn-file
  for (var FEN in FENs) {
    //make the FEN representation to an intern boardrepresentation
    FEN2Rep rep = new FEN2Rep();
    List<List<List<String>>> boardRepresentation = rep.getRepresentation(FEN);

    //render the gif and save them
    Rep2GIF gifs = new Rep2GIF();
    gifs.generateGIFImages(boardRepresentation, counter.toString());
    counter++;
  }
}
