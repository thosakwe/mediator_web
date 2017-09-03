import 'package:angular/angular.dart';
import 'ads.dart' as adsbygoogle;
import 'package:js/js_util.dart';

@Component(selector: 'x-ad', templateUrl: 'x_ad.html')
class XAdComponent implements AfterContentInit {
  @Input()
  String clientId, slot;

  @override
  ngAfterContentInit() {
    adsbygoogle.push(jsify({}));
  }
}