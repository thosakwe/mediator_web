import 'dart:async';
import 'package:angular/angular.dart';
import 'ads.dart' as adsbygoogle;
import 'package:js/js_util.dart';

@Component(selector: 'x-ad', templateUrl: 'x_ad.html')
class XAdComponent implements AfterContentInit, OnDestroy {
  final StreamController _adblock = new StreamController();

  @Input()
  String clientId, slot;

  @Output()
  Stream get adblock => _adblock.stream;

  @override
  ngAfterContentInit() {
    try {
      adsbygoogle.push(jsify({}));
    } catch(_) {
      _adblock.add(null);
    }
  }

  @override
  ngOnDestroy() {
    _adblock.close();
  }
}