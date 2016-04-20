@HtmlImport('learn_authentication_widget.html')
library plato_elements.learn_authentication_widget;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show UserInformation;
import 'learn_authentication_view.dart';
import 'user_information_view.dart';
import 'user_retriever.dart';

/// Silence analyzer:
/// [LearnAuthenticationView] - [UserInformationView] - [UserRetriever]
///
/// The [LearnAuthenticationWidget] class...
@PolymerRegister('learn-authentication-widget')
class LearnAuthenticationWidget extends PolymerElement {
  /// The [UserInformation] instance...
  @Property(notify: true)
  static UserInformation userInfo;

  /// The value of whether the user information has been loaded.
  bool get userLoaded => _userLoaded;

  /// The internal value of whether the user information has been loaded.
  bool _userLoaded;

  /// The [LearnAuthenticationWidget] factory constructor.
  factory LearnAuthenticationWidget() => document.createElement ('learn-authentication-widget');

  /// The [LearnAuthenticationWidget] named constructor.
  LearnAuthenticationWidget.created() : super.created();

  /// The [attached] method...
  void attached() {
    _userLoaded = false;
  }
}
