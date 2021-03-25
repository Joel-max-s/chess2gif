import 'package:image/image.dart';
import 'dart:io';

class Rep2GIF {
  //The absolute Filepath to the Folder with the Sprites
  String absoluteFilePath = '/home/joel/Dokumente/Projekte/chess2gif/sprites/';
  //The filename for the Sprite
  String file = 'sprite.gif';
  //The decoded Sprite
  final sprite = decodeGif(
      File('/home/joel/Dokumente/Projekte/chess2gif/sprites/sprite.gif')
          .readAsBytesSync());
  //Store the piece-sprites in a 2D List
  List<List<Image>> sprites =
      List.generate(8, (i) => List.generate(8, (j) => null));
  String whitePlayer;
  String blackPlayer;
  String whiteElo;
  String blackElo;
  //offset for playernames and playerelos
  int offset;
  //activates logentries
  bool logIsActive;

  Rep2GIF(String wP, String bP, String wE, String bE, bool log) {
    whitePlayer = wP;
    blackPlayer = bP;
    whiteElo = wE;
    blackElo = bE;
    logIsActive = log;
  }

  /**
   * render a gif-animation for a game
   * @param reps: 3D List that represents the game
   * @param filename: the filename for the gif-animation
   */
  void generateGIFImages(List<List<List<String>>> reps, String filename) {
    //fill the 2D List with Sprites from the Pieces
    prepareSprite();
    //the encoder for the gif encoding at the end
    GifEncoder encoder =
        new GifEncoder(delay: 100, repeat: 0, samplingFactor: 100);
    //store the generated image to increase Performance
    var lastimage;

    int count = 0;
    //loop through all game positions
    for (var rep in reps) {
      Image newImage;
      //for the first image: Make usernames on top and bottom
      if (count == 0) {
        if (whitePlayer != '' && blackPlayer != '') {
          newImage = new Image(1440, 1640);
          offset = 100;
          drawString(newImage, arial_48, 26, 26, '$blackPlayer $blackElo');
          drawString(newImage, arial_48, 26, 1566, '$whitePlayer $whiteElo');
        } else {
          newImage = new Image(1440, 1440);
          offset = 0;
        }
      }

      //for the other images: copy the last image and manipulate them, this is way more performant
      else
        newImage = lastimage;

      //loop through all squares from the position
      for (int i = 0; i < rep.length; i++) {
        for (int j = 0; j < rep[i].length; j++) {
          //if we are at the first position or the square is different the last time
          if (count == 0 || reps[count - 1][i][j] != reps[count][i][j]) {
            bool changeColor = true;
            //if we are before the first move
            if (count == 0)
              changeColor = false;
            //if we are at line 1 or 8, check if castled
            else if (i == 0 || i == 7) {
              changeColor = getIfCastled(i, j, rep[i][j]);
              //if castled
              if (!changeColor) rep[i][j] = rep[i][j][0];
            }

            //if we are not in the fist game
            //or in the last move on the piece was a King or a captured en-passent pawn
            if (count > 0 &&
                    (reps[count - 1][i][j] == 'k+' ||
                        reps[count - 1][i][j] == 'K+') &&
                    (reps[count][i][j] == 'k' || reps[count][i][j] == 'K') ||
                reps[count][i][j] == '-') changeColor = false;

            //calculate the piece and copy it to the right position
            var piece = getPiece(rep[i][j], i, j, changeColor);
            copyInto(newImage, piece, dstX: j * 180, dstY: i * 180 + offset);
          }

          //remove the 'moved' color from the move that was played 2 moves ago
          else if (count > 1 &&
              reps[count - 2][i][j] != reps[count - 1][i][j]) {
            var piece = getPiece(rep[i][j], i, j, false);
            copyInto(newImage, piece, dstX: j * 180, dstY: i * 180 + offset);
          }
        }
      }
      //add the calculated Image to the encoder
      encoder.addFrame(newImage);
      lastimage = newImage;
      if (logIsActive) print('${count + 1} from ${reps.length} are ready');
      count++;
    }
    //render the animation
    final animation = encoder.finish();
    File('/home/joel/Dokumente/Projekte/chess2gif/GIFs/$filename.gif')
        .writeAsBytesSync(animation);
  }

  /**
   * checks if the this move was a castling
   * @param i: row from the chessboard
   * @param j: column from the chessboard
   * @param piece: the chess-piece
   * @returns bool: if castled false, if not: true
   */
  bool getIfCastled(int i, int j, String piece) {
    if (piece.contains('s') && i == 0 && (j == 5 || j == 6))
      return false;
    else if (piece.contains('S') && i == 7 && (j == 5 || j == 6))
      return false;
    else if (piece.contains('l') && i == 0 && (j == 2 || j == 3))
      return false;
    else if (piece.contains('L') && i == 7 && (j == 2 || j == 3))
      return false;
    else
      return true;
  }

  /**
   * fill the Sprite 2D Array
   */
  void prepareSprite() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        sprites[i][j] = copyCrop(sprite, i * 180, j * 180, 180, 180);
      }
    }
  }

  /**
   * return the piece that is on the given square
   * @param piece: The String representation of the piece
   * @param xPos: the row from the chessboard
   * @param yPos: the column fron the chessboard
   * @param islast: if true: mark the square that this piece moved
   */
  Image getPiece(String piece, int xPos, int yPos, bool islast) {
    var imagePart;
    int offset = 0;
    if (islast) offset = 2;

    if ((xPos.isOdd && yPos.isOdd) || (xPos.isEven && yPos.isEven)) {
      switch (piece) {
        case 'r':
          imagePart = sprites[0 + offset][4];
          break;
        case 'n':
          imagePart = sprites[0 + offset][2];
          break;
        case 'b':
          imagePart = sprites[0 + offset][3];
          break;
        case 'q':
          imagePart = sprites[0 + offset][5];
          break;
        case 'k':
          imagePart = sprites[0 + offset][6];
          break;
        case 'k+':
          imagePart = sprites[0][7];
          break;
        case 'p':
          imagePart = sprites[0 + offset][1];
          break;
        case 'R':
          imagePart = sprites[4 + offset][4];
          break;
        case 'N':
          imagePart = sprites[4 + offset][2];
          break;
        case 'B':
          imagePart = sprites[4 + offset][3];
          break;
        case 'Q':
          imagePart = sprites[4 + offset][5];
          break;
        case 'K':
          imagePart = sprites[4 + offset][6];
          break;
        case 'K+':
          imagePart = sprites[4][7];
          break;
        case 'P':
          imagePart = sprites[4 + offset][1];
          break;
        default:
          imagePart = sprites[0 + offset][0];
      }
    } else {
      switch (piece) {
        case 'r':
          imagePart = sprites[1 + offset][4];
          break;
        case 'n':
          imagePart = sprites[1 + offset][2];
          break;
        case 'b':
          imagePart = sprites[1 + offset][3];
          break;
        case 'q':
          imagePart = sprites[1 + offset][5];
          break;
        case 'k':
          imagePart = sprites[1 + offset][6];
          break;
        case 'k+':
          imagePart = sprites[1][7];
          break;
        case 'p':
          imagePart = sprites[1 + offset][1];
          break;
        case 'R':
          imagePart = sprites[5 + offset][4];
          break;
        case 'N':
          imagePart = sprites[5 + offset][2];
          break;
        case 'B':
          imagePart = sprites[5 + offset][3];
          break;
        case 'Q':
          imagePart = sprites[5 + offset][5];
          break;
        case 'K':
          imagePart = sprites[5 + offset][6];
          break;
        case 'K+':
          imagePart = sprites[5][7];
          break;
        case 'P':
          imagePart = sprites[5 + offset][1];
          break;
        default:
          imagePart = sprites[1 + offset][0];
      }
    }
    return imagePart;
  }
}
