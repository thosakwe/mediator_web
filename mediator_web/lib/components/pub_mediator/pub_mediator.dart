import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:material_components_web/material_components_web.dart';
import '../../services/mediation.dart';
import '../x_ad/x_ad.dart';

@Component(
    selector: 'pub-mediator',
    templateUrl: 'pub_mediator.html',
    styleUrls: const [
      'pub_mediator.css'
    ],
    directives: const [
      mdcDirectives,
      COMMON_DIRECTIVES,
      NgModel,
      XAdComponent,
    ])
class PubMediatorComponent {
  bool loading = false;
  Map result = null;

  String pubspec = '';

  @ViewChild('dialog')
  MdcDialogComponent dialog;

  @ViewChild('error')
  MdcSnackbarComponent error;

  final MediationService _mediationService;

  PubMediatorComponent(this._mediationService);

  void handleClick() {
    if (pubspec?.trim()?.isNotEmpty != true) {
      error
        ..message = 'Please enter text.'
        ..show();
    } else {
      loading = true;

      _mediationService.mediate(pubspec).then((dd) {
        window.console
          ..info('PUB MEDIATOR LOG (verbose):')
          ..info(dd['log'])
          ..info(dd['conflicts']);
        result = dd;
        dialog.show();
      }).catchError((e, st) {
        window.console.error(e);
        error
          ..message = e.toString()
          ..show();
      }).whenComplete(() {
        loading = false;
      });
    }
  }
}
