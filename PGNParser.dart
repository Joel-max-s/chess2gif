import 'package:pgn_parser/pgn_parser.dart' as parse;
import 'package:chess/chess.dart';
import 'dart:io';

class PGNParser {
  int lastEPSquare = -1;
  List<List<List<String>>> parsePGN() {
    print('lol');
    parse.PgnParser pgnParser = new parse.PgnParser();
    print('lol');
    String pgn = File('test.pgn').readAsStringSync();
    print('lol');
    List<parse.PgnGame> games = pgnParser.parse(pgn);
    print('lol');
    //games.removeRange(2, games.length);
    List<List<List<String>>> FENs = List.empty(growable: true);
    for (var game in games) {
      var moves = game.moves();
      List<String> movesAsRaw = List.empty(growable: true);
      for (var move in moves) {
        print(move.san);
        movesAsRaw.add(move.raw);
      }
      FENs.add(generateFENS(movesAsRaw));
      print(game.pgn());
      //print(game.pgn());
    }
    return FENs;
  }

  List<List<String>> generateFENS(List<String> moves) {
    Chess chess = new Chess();
    List<List<String>> FENs = [
      ['rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'],
      ['']
    ];

    for (var move in moves) {
      var turned = chess.turn;
      var whiteTurned = false;
      if (turned.toString() == 'Color.WHITE') whiteTurned = true;
      //print(turned);
      chess.move(move);
      String square = Chess.SQUARES.keys.firstWhere((p) => Chess.SQUARES[p] == lastEPSquare, orElse: () => null);
      bool eptake = false;
      if(square != null) {
        String ep = chess.get(square).toString();
        if(ep != 'null')
          eptake = true;
      }
      FENs[0].add(chess.generate_fen());
      if (chess.in_check || chess.in_checkmate) {
        if (whiteTurned && !eptake)
          FENs[1].add('c');
        else if(whiteTurned && eptake)
          FENs[1].add('ce');
        else if(!whiteTurned && !eptake)
          FENs[1].add('C');
        else if(!whiteTurned && eptake)
          FENs[1].add('Ce');
      } else if (move == 'O-O' && whiteTurned)
        FENs[1].add('S');
      else if (move == 'O-O-O' && whiteTurned)
        FENs[1].add('L');
      else if (move == 'O-O' && !whiteTurned)
        FENs[1].add('s');
      else if (move == 'O-O-O' && !whiteTurned)
        FENs[1].add('l');
      else
        FENs[1].add('');

      lastEPSquare = chess.ep_square;
      print(lastEPSquare);
    }
    return FENs;
  }
}
