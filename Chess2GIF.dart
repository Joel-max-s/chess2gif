import 'PGNParser.dart';
import 'FEN2Rep.dart';
import 'Rep2GIF.dart';

void main(List<String> args) {

  PGNParser parser = new PGNParser();
  List<List<String>> FENs = parser.parsePGN();
  
  FEN2Rep rep = new FEN2Rep();
  List<List<List<String>>> boardRepresentation = rep.getRepresentation(FENs);

  Rep2GIF gifs = new Rep2GIF();
  gifs.generateGIFImages(boardRepresentation);
}