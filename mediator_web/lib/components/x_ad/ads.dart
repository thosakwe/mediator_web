@JS()
library adsbygoogle;

import 'package:js/js.dart';

@JS()
external AdsByGoogle get adsbygoogle;

@JS()
abstract class AdsByGoogle {
  @JS()
  external bool get loaded;

  @JS()
  external void push(x);
}