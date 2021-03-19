import 'PGNParser.dart';
import 'FEN2Rep.dart';
import 'Rep2GIF.dart';

void main(List<String> args) {
  PGNParser parser = new PGNParser();
  List<List<List<String>>> FENs = parser.parsePGN();
  int counter = 0;
  for (var FEN in FENs) {
    FEN2Rep rep = new FEN2Rep();
    List<List<List<String>>> boardRepresentation = rep.getRepresentation(FEN);

    Rep2GIF gifs = new Rep2GIF();
    gifs.generateGIFImages(boardRepresentation, counter.toString());
    counter++;
  }
}
