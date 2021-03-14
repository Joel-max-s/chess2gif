import 'package:chess/chess.dart';
import 'dart:io';

class PGNParser {

  List<String> parsePGN() {

    RegExp firstSplit = new RegExp(r'[0-9]+.\ *(([a-zA-Z0-9+-]+\ [a-zA-Z0-9+-]+\ )|([a-zA-Z0-9+-]+\ ))');
    RegExp secondSplit = new RegExp(r'[a-zA-Z][a-zA-Z0-9+-]+');

    String pgn = File('test.pgn').readAsStringSync().replaceAll('\n', ' '); 

    //File('testGame.pgn').readAsString().then((String content) => content);
    
    print(pgn);

    //String pgn = '1.e4 c6 2.d4 d5 3.Nc3 dxe4 4.Nxe4 Nd7 5.Ng5 Ngf6 6.Bd3 e6 7.N1f3 h6 8.Nxe6 Qe7 9.O-O fxe6 10.Bg6+ Kd8 {Kasparov schüttelt kurz den Kopf} 11.Bf4 b5 12.a4 Bb7 13.Re1 Nd5 14.Bg3 Kc8 15.axb5 cxb5 16.Qd3 Bc6 17.Bf5 exf5 18.Rxe7 Bxe7 19.c4 1-0';

    Iterable<Match> firstSplitPGN = firstSplit.allMatches(pgn);

    firstSplitPGN.forEach((m)=>print(m.group(0)));

    List<String> secondSplitPGN = new List.empty(growable: true);
    for (var m in firstSplitPGN) {

      Iterable<Match> temp = secondSplit.allMatches(m.group(0));

      temp.forEach((e)=>secondSplitPGN.add(e.group(0)));
    }

    secondSplitPGN.forEach((m)=>print(m));
    
    List<String> FENs = generateFENS(secondSplitPGN);

    return FENs;
  }

  List<String> generateFENS(List<String> moves) {
    Chess chess = new Chess();
    //chess.load_pgn(pgn)


    List<String> FENs = List.empty(growable: true);
    for (var move in moves) {
      chess.move(move);
      FENs.add(chess.generate_fen());
    }

    for (var fen in FENs) {
      print(fen);
    }
    return FENs;
  }
}