import 'package:image/image.dart';
import 'dart:io';

class Rep2GIF {
  void generateGIFImages(List<List<List<String>>> reps) {
    GifEncoder encoder = new GifEncoder(delay: 100, repeat: 0, samplingFactor: 100);

    int count = 0;
    var lastimage;
    for (var rep in reps) {
      Image newImage;
      if(count == 0)
        newImage = new Image(1440, 1440);
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
            copyInto(newImage, piece, dstX: j * 180, dstY: i * 180);
          }
          else if(count > 1 && reps[count - 2][i][j] != reps[count - 1][i][j]) {
            var piece = getPiece(rep[i][j], i, j, false);
            copyInto(newImage, piece, dstX: j * 180, dstY: i * 180);
          }
        }
      }
      encoder.addFrame(newImage);
      lastimage = newImage;
      print('${count + 1} from ${reps.length} are ready');
      count++;
    }
    final animation = encoder.finish();
    File('animation.gif').writeAsBytesSync(animation);
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
  
  Image getPiece(String piece, int xPos, int yPos, bool islast) {
    var imagePart;
    final image = decodeGif(File('sprite.gif').readAsBytesSync());
    int offset = 0;
    if (islast)
      offset = 360;

    if ((xPos.isOdd && yPos.isOdd) || (xPos.isEven && yPos.isEven)) {
      switch (piece) {
        case 'r':
          imagePart = copyCrop(image, 0 + offset, 720, 180, 180);
          break;
        case 'n':
          imagePart = copyCrop(image, 0 + offset, 360, 180, 180);
          break;
        case 'b':
          imagePart = copyCrop(image, 0 + offset, 540, 180, 180);
          break;
        case 'q':
          imagePart = copyCrop(image, 0 + offset, 900, 180, 180);
          break;
        case 'k':
          imagePart = copyCrop(image, 0 + offset, 1080, 180, 180);
          break;
        case 'k+':
          imagePart = copyCrop(image, 0, 1260, 180, 180);
          break;
        case 'p':
          imagePart = copyCrop(image, 0 + offset, 180, 180, 180);
          break;
        case 'R':
          imagePart = copyCrop(image, 720 + offset, 720, 180, 180);
          break;
        case 'N':
          imagePart = copyCrop(image, 720 + offset, 360, 180, 180);
          break;
        case 'B':
          imagePart = copyCrop(image, 720 + offset, 540, 180, 180);
          break;
        case 'Q':
          imagePart = copyCrop(image, 720 + offset, 900, 180, 180);
          break;
        case 'K':
          imagePart = copyCrop(image, 720 + offset, 1080, 180, 180);
          break;
        case 'K+':
          imagePart = copyCrop(image, 720, 1260, 180, 180);
          break;
        case 'P':
          imagePart = copyCrop(image, 720 + offset, 180, 180, 180);
          break;
        default:
          imagePart = copyCrop(image, 0 + offset, 0, 180, 180);
      }
    } else {
      switch (piece) {
        case 'r':
          imagePart = copyCrop(image, 180 + offset, 720, 180, 180);
          break;
        case 'n':
          imagePart = copyCrop(image, 180 + offset, 360, 180, 180);
          break;
        case 'b':
          imagePart = copyCrop(image, 180 + offset, 540, 180, 180);
          break;
        case 'q':
          imagePart = copyCrop(image, 180 + offset, 900, 180, 180);
          break;
        case 'k':
          imagePart = copyCrop(image, 180 + offset, 1080, 180, 180);
          break;
        case 'k+':
          imagePart = copyCrop(image, 180, 1260, 180, 180);
          break;
        case 'p':
          imagePart = copyCrop(image, 180 + offset, 180, 180, 180);
          break;
        case 'R':
          imagePart = copyCrop(image, 900 + offset, 720, 180, 180);
          break;
        case 'N':
          imagePart = copyCrop(image, 900 + offset, 360, 180, 180);
          break;
        case 'B':
          imagePart = copyCrop(image, 900 + offset, 540, 180, 180);
          break;
        case 'Q':
          imagePart = copyCrop(image, 900 + offset, 900, 180, 180);
          break;
        case 'K':
          imagePart = copyCrop(image, 900 + offset, 1080, 180, 180);
          break;
        case 'K+':
          imagePart = copyCrop(image, 900, 1260, 180, 180);
          break;
        case 'P':
          imagePart = copyCrop(image, 900 + offset, 180, 180, 180);
          break;
        default:
          imagePart = copyCrop(image, 180 + offset, 0, 180, 180);
      }
    }
    return imagePart;
  }
}
