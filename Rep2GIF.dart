import 'package:image/image.dart';
import 'dart:io';

class Rep2GIF {
  final sprite = decodeGif(File('sprite.gif').readAsBytesSync());
  List<List<Image>> sprites = List.generate(8, (i) => List.generate(8, (j) => null));


  void generateGIFImages(List<List<List<String>>> reps, String filename) {
    prepareSprite();
    GifEncoder encoder = new GifEncoder(delay: 100, repeat: 0, samplingFactor: 100);

    int count = 0;
    var lastimage;
    for (var rep in reps) {
      Image newImage;
      if(count == 0) {
        newImage = new Image(1440, 1640);
        drawString(newImage, arial_48, 20, 20, 'KJJ01');
        drawString(newImage, arial_48, 20, 1560, 'other Player');
      }
      else
        newImage = lastimage;
      for (int i = 0; i < rep.length; i++) {
        for (int j = 0; j < rep[i].length; j++) {
          if(count == 0 || reps[count - 1][i][j] != reps[count][i][j]) {
            bool changeColor = true;
            if(i == 0 || i ==7) {
              changeColor = getIfCastled(i, j, rep[i][j]);
              if(changeColor == false)
                rep[i][j] = rep[i][j][0];
            }
            if(count == 0)
              changeColor = false;
            if(count > 0 && (reps[count - 1][i][j] == 'k+' || reps[count - 1][i][j] == 'K+') && (reps[count][i][j] == 'k' || reps[count][i][j] == 'K'))
              changeColor = false;
            var piece = getPiece(rep[i][j], i, j, changeColor);
            copyInto(newImage, piece, dstX: j * 180, dstY: i * 180 + 100);
          }
          else if(count > 1 && reps[count - 2][i][j] != reps[count - 1][i][j]) {
            var piece = getPiece(rep[i][j], i, j, false);
            copyInto(newImage, piece, dstX: j * 180, dstY: i * 180 + 100);
          }
        }
      }
      encoder.addFrame(newImage);
      lastimage = newImage;
      //print('${count + 1} from ${reps.length} are ready');
      count++;
    }
    final animation = encoder.finish();
    File('GIFs/$filename.gif').writeAsBytesSync(animation);
  }

  bool getIfCastled(int i, int j, String piece) {
    if(piece.contains('s') && i == 0 && (j == 5 || j == 6))
      return false;
    else if(piece.contains('S') && i == 7 && (j == 5 || j == 6))
      return false;
    else if(piece.contains('l') && i == 0 && (j == 2 || j == 3))
      return false;
    else if(piece.contains('L') && i == 7 && (j == 2 || j == 3))
      return false;
    else
      return true;
  }
  
  void prepareSprite() {
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        sprites[i][j] = copyCrop(sprite, i*180, j*180, 180, 180);
      }
    }
  }

  Image getPiece(String piece, int xPos, int yPos, bool islast) {
    var imagePart;
    int offset = 0;
    if (islast)
      offset = 2;

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

  /*void blabla() {
    if ((xPos.isOdd && yPos.isOdd) || (xPos.isEven && yPos.isEven)) {
      switch (piece) {
        case 'r':
          imagePart = copyCrop(sprite, 0 + offset, 720, 180, 180);
          break;
        case 'n':
          imagePart = copyCrop(sprite, 0 + offset, 360, 180, 180);
          break;
        case 'b':
          imagePart = copyCrop(sprite, 0 + offset, 540, 180, 180);
          break;
        case 'q':
          imagePart = copyCrop(sprite, 0 + offset, 900, 180, 180);
          break;
        case 'k':
          imagePart = copyCrop(sprite, 0 + offset, 1080, 180, 180);
          break;
        case 'k+':
          imagePart = copyCrop(sprite, 0, 1260, 180, 180);
          break;
        case 'p':
          imagePart = copyCrop(sprite, 0 + offset, 180, 180, 180);
          break;
        case 'R':
          imagePart = copyCrop(sprite, 720 + offset, 720, 180, 180);
          break;
        case 'N':
          imagePart = copyCrop(sprite, 720 + offset, 360, 180, 180);
          break;
        case 'B':
          imagePart = copyCrop(sprite, 720 + offset, 540, 180, 180);
          break;
        case 'Q':
          imagePart = copyCrop(sprite, 720 + offset, 900, 180, 180);
          break;
        case 'K':
          imagePart = copyCrop(sprite, 720 + offset, 1080, 180, 180);
          break;
        case 'K+':
          imagePart = copyCrop(sprite, 720, 1260, 180, 180);
          break;
        case 'P':
          imagePart = copyCrop(sprite, 720 + offset, 180, 180, 180);
          break;
        default:
          imagePart = copyCrop(sprite, 0 + offset, 0, 180, 180);
      }
    } else {
      switch (piece) {
        case 'r':
          imagePart = copyCrop(sprite, 180 + offset, 720, 180, 180);
          break;
        case 'n':
          imagePart = copyCrop(sprite, 180 + offset, 360, 180, 180);
          break;
        case 'b':
          imagePart = copyCrop(sprite, 180 + offset, 540, 180, 180);
          break;
        case 'q':
          imagePart = copyCrop(sprite, 180 + offset, 900, 180, 180);
          break;
        case 'k':
          imagePart = copyCrop(sprite, 180 + offset, 1080, 180, 180);
          break;
        case 'k+':
          imagePart = copyCrop(sprite, 180, 1260, 180, 180);
          break;
        case 'p':
          imagePart = copyCrop(sprite, 180 + offset, 180, 180, 180);
          break;
        case 'R':
          imagePart = copyCrop(sprite, 900 + offset, 720, 180, 180);
          break;
        case 'N':
          imagePart = copyCrop(sprite, 900 + offset, 360, 180, 180);
          break;
        case 'B':
          imagePart = copyCrop(sprite, 900 + offset, 540, 180, 180);
          break;
        case 'Q':
          imagePart = copyCrop(sprite, 900 + offset, 900, 180, 180);
          break;
        case 'K':
          imagePart = copyCrop(sprite, 900 + offset, 1080, 180, 180);
          break;
        case 'K+':
          imagePart = copyCrop(sprite, 900, 1260, 180, 180);
          break;
        case 'P':
          imagePart = copyCrop(sprite, 900 + offset, 180, 180, 180);
          break;
        default:
          imagePart = copyCrop(sprite, 180 + offset, 0, 180, 180);
      }
    }
  }*/
}
