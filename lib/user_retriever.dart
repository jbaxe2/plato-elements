@HtmlImport('user_retriever.html')
library plato.elements.retriever.user;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show UserInformation;
import 'simple_retriever.dart';

/// The [UserRetriever] class...
@PolymerRegister('user-retriever')
class UserRetriever extends PolymerElement {
  /// The Learn username for the user.
  @Property(notify: true)
  String username;

  /// The Learn password for the user.
  @Property(notify: true)
  String password;

  /// The [UserInformation] instance, to be initialized once user info is retrieved.
  @Property(notify: true)
  UserInformation userInfo;

  @Property(notify: true)
  bool isLtiSession;

  /// The [UserRetriever] factory constructor.
  factory UserRetriever() => document.createElement ('user-retriever');

  /// The [UserRetriever] named constructor.
  UserRetriever.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [retrieveUserInfo] method...
  void retrieveUserInfo() {
    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': {
      'message': 'Retrieving the Plato user information.'
    }});

    ($['user-retriever'] as SimpleRetriever).retrieveTypedData();
  }

  /// The [onUserRetrieved] method...
  @Listen('user-retrieved')
  void onUserRetrieved (CustomEvent event, details) {
    if (null != details['user']) {
      var user = details['user'];

      try {
        set ('userInfo',
          new UserInformation (
            username, password,
            user['learn.user.firstName'],
            user['learn.user.lastName'],
            user['learn.user.email'],
            user['banner.user.cwid'],
            isLtiSession
          )
        );

        this.fire ('updated-user-info', canBubble: true);
      } catch (_) {}

      this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});
      this.fire ('iron-signal', detail: {'name': 'user-retrieved-complete', 'data': null});
    }
  }
}
