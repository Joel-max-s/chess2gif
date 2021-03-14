import 'package:chess/chess.dart';
import 'dart:io';

class PGNParser {

  List<List<String>> parsePGN() {

    RegExp firstSplit = new RegExp(r'[0-9]+.\ *(([a-zA-Z0-9+-]+\ [a-zA-Z0-9+-]+\ )|([a-zA-Z0-9+-]+\ ))');
    RegExp secondSplit = new RegExp(r'[a-zA-Z][a-zA-Z0-9+-]+');

    String pgn = File('testGame.pgn').readAsStringSync().replaceAll('\n', ' '); 
    
    print(pgn);

    Iterable<Match> firstSplitPGN = firstSplit.allMatches(pgn);

    firstSplitPGN.forEach((m)=>print(m.group(0)));

    List<String> secondSplitPGN = new List.empty(growable: true);
    for (var m in firstSplitPGN) {

      Iterable<Match> temp = secondSplit.allMatches(m.group(0));

      temp.forEach((e)=>secondSplitPGN.add(e.group(0)));
    }

    secondSplitPGN.forEach((m)=>print(m));
    
    List<List<String>> FENs = generateFENS(secondSplitPGN);

    return FENs;
  }

  List<List<String>> generateFENS(List<String> moves) {
    Chess chess = new Chess();
    List<List<String>> FENs = [['rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'], ['']];

    for (var move in moves) {
      var turned = chess.turn;
      print(turned);
      chess.move(move);
      FENs[0].add(chess.generate_fen());
      if(chess.in_check || chess.in_checkmate) {
        if (turned.toString() == 'Color.WHITE')
          FENs[1].add('c');
        else
          FENs[1].add('C');
      }
      else
        FENs[1].add('');
    }

    return FENs;
  }
}