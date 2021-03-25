import 'PGNParser.dart';
import 'FEN2Rep.dart';
import 'Rep2GIF.dart';

Future<void> main(List<String> args) async{
  //parse the PGN file
  PGNParser parser = new PGNParser(false);
  List<List<List<String>>> FENs = await parser.parsePGN();
  List<String> whitePlayers = parser.whitePlayers;
  List<String> blackPlayers = parser.blackPlayers;
  List<String> whiteElos = parser.whiteElos;
  List<String> blackElos = parser.blackElos;

  int counter = 0;
  //for every game in the pgn-file
  for (var FEN in FENs) {
    //make the FEN representation to an intern boardrepresentation
    FEN2Rep rep = new FEN2Rep(false);
    List<List<List<String>>> boardRepresentation = rep.getRepresentation(FEN);

    //render the gif and save them
    Rep2GIF gifs = new Rep2GIF(whitePlayers[counter], blackPlayers[counter], whiteElos[counter], blackElos[counter], false);
    gifs.generateGIFImages(boardRepresentation, counter.toString());
    print('${counter + 1} from ${FENs.length} are ready');
    counter++;
  }
}
