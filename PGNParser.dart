import 'package:pgn_parser/pgn_parser.dart' as parse;
import 'package:chess/chess.dart';
import 'dart:io';

class PGNParser {
  int lastEPSquare = -1;
  List<List<List<String>>> parsePGN() {
    parse.PgnParser pgnParser = new parse.PgnParser();
    String pgn = File('test.pgn').readAsStringSync();
    pgn += ' ';
    List<parse.PgnGame> games = pgnParser.parse(pgn);
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
        if(chess.get(square) != null) {
          PieceType pieceOnEpSquare = chess.get(square).type;
          print(pieceOnEpSquare.toString());
          if(pieceOnEpSquare.toString() == 'p') {
            eptake = true;
          }
        }
        
          
      }
      FENs[0].add(chess.generate_fen());
      if (chess.in_check || chess.in_checkmate) {
        if (whiteTurned && !eptake)
          FENs[1].add('c');
        else if(whiteTurned && eptake)
          FENs[1].add('c' + lastEPSquare.toString());
        else if(!whiteTurned && !eptake)
          FENs[1].add('C');
        else if(!whiteTurned && eptake)
          FENs[1].add('C' + lastEPSquare.toString());
      } else if (move == 'O-O' && whiteTurned)
        FENs[1].add('S');
      else if (move == 'O-O-O' && whiteTurned)
        FENs[1].add('L');
      else if (move == 'O-O' && !whiteTurned)
        FENs[1].add('s');
      else if (move == 'O-O-O' && !whiteTurned)
        FENs[1].add('l');
      else if(eptake)
        FENs[1].add(' ' + lastEPSquare.toString());
      else
        FENs[1].add('');

      print(FENs[1]);
      lastEPSquare = chess.ep_square;
      //print(lastEPSquare);
    }
    return FENs;
  }
}
