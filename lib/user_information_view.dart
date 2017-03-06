@HtmlImport('user_information_view.html')
library plato.elements.view.user.inforamtion;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_material.dart';

import 'data_models.dart' show UserInformation;

/// Silence analyzer:
/// [IronSignals] - [PaperMaterial]
///
/// The [UserInformationView] class...
@PolymerRegister('user-information-view')
class UserInformationView extends PolymerElement {
  @Property(notify: true)
  UserInformation userInfo;

  /// The [UserInformationView] factory constructor.
  factory UserInformationView() => document.createElement ('user-information-view');

  /// The [UserInformationView] constructor.
  UserInformationView.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [onCollectInfoCrfReview] method...
  @Listen('iron-signal-collect-info-crf-review')
  void onCollectInfoCrfReview (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {
      'name': 'ollect-user-info', 'data': {'userInfo': userInfo}
    });
  }
}
