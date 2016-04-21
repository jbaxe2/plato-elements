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
  @Property(notify: true)
  String username;

  @Property(notify: true)
  String password;

  /// The [UserInformation] instance...
  @Property(notify: true)
  UserInformation userInfo;

  /// The value of whether the user information has been loaded.
  @Property(notify: true)
  bool get userLoaded => _userLoaded;

  /// The internal value of whether the user information has been loaded.
  bool _userLoaded = false;

  /// An internal flag for whether we're currently attempting authentication.
  bool _inUserLoading = false;

  /// The [LearnAuthenticationWidget] factory constructor.
  factory LearnAuthenticationWidget() => document.createElement ('learn-authentication-widget');

  /// The [LearnAuthenticationWidget] named constructor.
  LearnAuthenticationWidget.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [handleUserRetrieval] method...
  @Listen('retrieve-user')
  void handleUserRetrieval (CustomEvent event, details) {
    if (!(_inUserLoading && _userLoaded)) {
      _inUserLoading = true;

      notifyPath ('username', username);
      notifyPath ('password', password);

      ($['user-retriever-elmnt'] as UserRetriever).loadUserInfo ();

      async (() => _inUserLoading = false);
    }
  }

  /// The [updateUserInfo] method...
  @Listen('update-user-info')
  void updateUserInfo (CustomEvent event, details) {
    notifyPath ('userInfo', userInfo);
    notifyPath ('userLoaded', _userLoaded = true);
  }
}
