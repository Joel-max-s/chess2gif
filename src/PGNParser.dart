import 'package:pgn_parser/pgn_parser.dart' as parse;
import 'package:chess/chess.dart';
import 'dart:io';

/**
 * Parse the given pgn file
 */
class PGNParser {
  //activates logentries
  bool logIsActive;
  //store the last en passant square
  int lastEPSquare = -1;
  List<String> whitePlayers = List.empty(growable: true);
  List<String> blackPlayers = List.empty(growable: true);
  List<String> whiteElos = List.empty(growable: true);
  List<String> blackElos = List.empty(growable: true);

  PGNParser(bool log) {
    logIsActive = log;
  }

  /**
   * parse the given pgn file
   * @returns: a 3D List wich contains games, int the game the given fens and some extra information
   */
  List<List<List<String>>> parsePGN() {
    //create a pgn parser and store the pgn in a string
    parse.PgnParser pgnParser = new parse.PgnParser();
    String absolutePath = '/home/joel/Dokumente/Projekte/chess2gif/PGNs/';
    String fileName = 'kjj.pgn';
    String pgn = File(absolutePath + fileName).readAsStringSync();
    pgn += ' ';

    //Parse the pgn and store the games
    List<parse.PgnGame> games = pgnParser.parse(pgn);
    //games.removeRange(2, games.length);
    int counter = 1;
    for (var game in games) {
      var gameHeaders = game.headers;
      for (int i = 0; i < game.headers.length; i++) {
        switch (gameHeaders[i].name) {
          case 'White':
            whitePlayers.add(gameHeaders[i].value);
            break;
          case 'Black':
            blackPlayers.add(gameHeaders[i].value);
            break;
          case 'WhiteElo':
            whiteElos.add('(${gameHeaders[i].value})');
            break;
          case 'BlackElo':
            blackElos.add('(${gameHeaders[i].value})');
            break;
        }
      }
      if (whitePlayers.length != counter) whitePlayers.add('');
      if (blackPlayers.length != counter) blackPlayers.add('');
      if (whiteElos.length != counter) whiteElos.add('');
      if (blackElos.length != counter) blackElos.add('');
      if (logIsActive) {
        print(whitePlayers.toString());
        print(blackPlayers.toString());
        print(whiteElos.toString());
        print(blackElos.toString());
      }
      counter++;
    }

    //a 3D List wich contains games, int the game the given fens and some extra information
    List<List<List<String>>> FENs = List.empty(growable: true);

    //parse the game and make them to FEN
    for (var game in games) {
      var moves = game.moves();
      List<String> movesAsRaw = List.empty(growable: true);
      for (var move in moves) {
        if (logIsActive) print(move.san);
        movesAsRaw.add(move.raw);
      }
      FENs.add(generateFENS(movesAsRaw));
      if (logIsActive) print(game.pgn());
    }
    return FENs;
  }

  /**
   * generate FENs
   * @returns: 2D List with FEN and extra information
   */
  List<List<String>> generateFENS(List<String> moves) {
    Chess chess = new Chess();
    //starting Position
    List<List<String>> FENs = [
      ['rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'],
      ['']
    ];

    //make the move to a FEN and add extra position
    //loop through all moves
    for (var move in moves) {
      var turned = chess.turn;
      var whiteTurned = false;

      //if white turned
      if (turned.toString() == 'Color.WHITE') whiteTurned = true;
      chess.move(move);

      //check if en passant happend
      String square = Chess.SQUARES.keys.firstWhere(
          (p) => Chess.SQUARES[p] == lastEPSquare,
          orElse: () => null);
      bool eptake = false;
      if (square != null) {
        if (chess.get(square) != null) {
          PieceType pieceOnEpSquare = chess.get(square).type;
          if (logIsActive) print(pieceOnEpSquare.toString());
          if (pieceOnEpSquare.toString() == 'p') {
            eptake = true;
          }
        }
      }
      FENs[0].add(chess.generate_fen());

      //add extra information (check, castling, en passant)
      if (chess.in_check || chess.in_checkmate) {
        if (whiteTurned && !eptake)
          FENs[1].add('c');
        else if (whiteTurned && eptake)
          FENs[1].add('c' + lastEPSquare.toString());
        else if (!whiteTurned && !eptake)
          FENs[1].add('C');
        else if (!whiteTurned && eptake)
          FENs[1].add('C' + lastEPSquare.toString());
      } else if (move == 'O-O' && whiteTurned)
        FENs[1].add('S');
      else if (move == 'O-O-O' && whiteTurned)
        FENs[1].add('L');
      else if (move == 'O-O' && !whiteTurned)
        FENs[1].add('s');
      else if (move == 'O-O-O' && !whiteTurned)
        FENs[1].add('l');
      else if (eptake)
        FENs[1].add(' ' + lastEPSquare.toString());
      else
        FENs[1].add('');

      //store the last possible en passant square
      lastEPSquare = chess.ep_square;
    }
    return FENs;
  }
}
