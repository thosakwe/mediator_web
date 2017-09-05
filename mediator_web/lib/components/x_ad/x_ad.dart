import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'ads.dart';
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
    new Timer(const Duration(seconds: 1), () {
      if (adsbygoogle?.loaded != true) {
        window.console
          ..info('window.adsbygoogle is null')
          ..info(adsbygoogle);
        _adblock.add(null);
      } else {
        try {
          adsbygoogle.push(jsify({}));
        } catch (e, st) {
          window.console
            ..error('Could not load advertisement...')
            ..error(e)
            ..error(st);
          _adblock.add(null);
        }
      }
    });
  }

  @override
  ngOnDestroy() {
    _adblock.close();
  }
}
