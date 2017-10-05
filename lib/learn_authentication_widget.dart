@HtmlImport('learn_authentication_widget.html')
library plato.elements.widget.learn_authentication;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'archives_collection.dart';
import 'data_models.dart' show UserInformation;
import 'enrollments_collection.dart';
import 'learn_authentication_view.dart';
import 'user_information_view.dart';
import 'user_retriever.dart';

/// Silence analyzer:
/// [IronSignals]
/// [LearnAuthenticationView] - [UserInformationView]
/// [UserRetriever]
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

  /// The value of whether the user information has been retrieved.
  @Property(notify: true)
  bool get userLoaded => _userLoaded;

  /// The internal value of whether the user information has been retrieved.
  bool _userLoaded = false;

  /// An internal flag for whether we're currently attempting authentication.
  bool _inUserLoading = false;

  /// The [LearnAuthenticationWidget] factory constructor.
  factory LearnAuthenticationWidget() =>
    document.createElement ('learn-authentication-widget');

  /// The [LearnAuthenticationWidget] named constructor.
  LearnAuthenticationWidget.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [onRetrieveUser] method...
  @Listen('retrieve-user')
  void onRetrieveUser (CustomEvent event, details) {
    if (!(_inUserLoading && _userLoaded)) {
      _inUserLoading = true;

      notifyPath ('username', username);
      notifyPath ('password', password);

      ($['user-retriever'] as UserRetriever).retrieveUserInfo();

      async (() => _inUserLoading = false);
    }
  }

  /// The [onUpdatedUserInfo] method...
  @Listen('updated-user-info')
  void onUpdatedUserInfo (CustomEvent event, details) {
    notifyPath ('userLoaded', _userLoaded = true);

    ($['enrollments-collection'] as EnrollmentsCollection).retrieveEnrollments();
  }

  @Listen('iron-signal-retrieve-archives-ready')
  void onRetrieveArchivesReady (CustomEvent event, details) =>
    ($['archives-collection'] as ArchivesCollection).retrieveArchives();
}
