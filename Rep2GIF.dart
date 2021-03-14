import 'package:image/image.dart';
import 'dart:io';

class Rep2GIF {
  void generateGIFImages(List<List<List<String>>> reps) {
    int count = 0;
    var gifImages = new List.empty(growable: true);
    for (var rep in reps) {
      var newImage = Image(1440, 1440);
      for (int i = 0; i < rep.length; i++) {
        for (int j = 0; j < rep[i].length; j++) {
          var piece = getPiece(rep[i][j], i, j);
          copyInto(newImage, piece, dstX: j * 180, dstY: i * 180);
        }
      }
      gifImages.add(newImage);
      print('$count from ${reps.length} are ready');
      count++;
    }
    makeGIF(gifImages);
  }

  void makeGIF(List images) {
    GifEncoder encoder = new GifEncoder(delay: 100, repeat: 0, samplingFactor: 1000);
    for (var frame in images) {
      encoder.addFrame(frame);
    }
    var animation = encoder.finish();

    File('finishedGIF.gif').writeAsBytesSync(animation);
  }

  Image getPiece(String piece, int xPos, int yPos) {
    var imagePart;
    final image = decodeGif(File('sprite.gif').readAsBytesSync());

    if ((xPos.isOdd && yPos.isOdd) || (xPos.isEven && yPos.isEven)) {
      switch (piece) {
        case 'r':
          imagePart = copyCrop(image, 0, 720, 180, 180);
          break;
        case 'n':
          imagePart = copyCrop(image, 0, 360, 180, 180);
          break;
        case 'b':
          imagePart = copyCrop(image, 0, 540, 180, 180);
          break;
        case 'q':
          imagePart = copyCrop(image, 0, 900, 180, 180);
          break;
        case 'k':
          imagePart = copyCrop(image, 0, 1080, 180, 180);
          break;
        case 'k+':
          imagePart = copyCrop(image, 0, 1260, 180, 180);
          break;
        case 'p':
          imagePart = copyCrop(image, 0, 180, 180, 180);
          break;
        case 'R':
          imagePart = copyCrop(image, 720, 720, 180, 180);
          break;
        case 'N':
          imagePart = copyCrop(image, 720, 360, 180, 180);
          break;
        case 'B':
          imagePart = copyCrop(image, 720, 540, 180, 180);
          break;
        case 'Q':
          imagePart = copyCrop(image, 720, 900, 180, 180);
          break;
        case 'K':
          imagePart = copyCrop(image, 720, 1080, 180, 180);
          break;
        case 'K+':
          imagePart = copyCrop(image, 720, 1260, 180, 180);
          break;
        case 'P':
          imagePart = copyCrop(image, 720, 180, 180, 180);
          break;
        default:
          imagePart = copyCrop(image, 0, 0, 180, 180);
      }
    } else {
      switch (piece) {
        case 'r':
          imagePart = copyCrop(image, 180, 720, 180, 180);
          break;
        case 'n':
          imagePart = copyCrop(image, 180, 360, 180, 180);
          break;
        case 'b':
          imagePart = copyCrop(image, 180, 540, 180, 180);
          break;
        case 'q':
          imagePart = copyCrop(image, 180, 900, 180, 180);
          break;
        case 'k':
          imagePart = copyCrop(image, 180, 1080, 180, 180);
          break;
        case 'k+':
          imagePart = copyCrop(image, 180, 1260, 180, 180);
          break;
        case 'p':
          imagePart = copyCrop(image, 180, 180, 180, 180);
          break;
        case 'R':
          imagePart = copyCrop(image, 900, 720, 180, 180);
          break;
        case 'N':
          imagePart = copyCrop(image, 900, 360, 180, 180);
          break;
        case 'B':
          imagePart = copyCrop(image, 900, 540, 180, 180);
          break;
        case 'Q':
          imagePart = copyCrop(image, 900, 900, 180, 180);
          break;
        case 'K':
          imagePart = copyCrop(image, 900, 1080, 180, 180);
          break;
        case 'K+':
          imagePart = copyCrop(image, 900, 1260, 180, 180);
          break;
        case 'P':
          imagePart = copyCrop(image, 900, 180, 180, 180);
          break;
        default:
          imagePart = copyCrop(image, 180, 0, 180, 180);
      }
    }
    return imagePart;
  }
}
