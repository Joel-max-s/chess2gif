import 'dart:io';

import 'package:image/image.dart';

void main() {
  Image image = new Image(500, 500);
  fill(image, getColor(0,0,255));
  drawString(image, arial_24, 0, 0, 'Hello World');

  File('test.gif').writeAsBytesSync(encodeGif(image));
}