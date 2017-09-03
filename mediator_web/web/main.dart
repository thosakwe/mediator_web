import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:mediator_web/components/pub_mediator/pub_mediator.dart';
import 'package:mediator_web/services/mediation.dart';

main() {
  bootstrap(PubMediatorComponent, [
    ROUTER_PROVIDERS,
    MediationService,
    const Provider(LocationStrategy, useClass: HashLocationStrategy),
  ]);
}
