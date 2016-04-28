@HtmlImport('user_retriever.html')
library plato_elements.user_retriever;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show UserInformation;
import 'simple_loader.dart';

/// Silence analyzer:  [SimpleLoader]
///
/// The [UserRetriever] class...
@PolymerRegister('user-retriever')
class UserRetriever extends PolymerElement {
  /// The Learn username for the user.
  @Property(notify: true)
  String username;

  /// The Learn password for the user.
  @Property(notify: true)
  String password;

  /// The [UserInformation] instance, to be initialized once user info is loaded.
  @Property(notify: true)
  UserInformation userInfo;

  /// The [UserRetriever] factory constructor.
  factory UserRetriever() => document.createElement ('user-retriever');

  /// The [UserRetriever] named constructor.
  UserRetriever.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [loadUserInfo] method...
  void loadUserInfo() {
    ($['user-loader'] as SimpleLoader).loadTypedData (
      data: {'username': username, 'password': password}
    );
  }

  /// The [onUserLoaded] method...
  @Listen('user-loaded')
  void onUserLoaded (CustomEvent event, details) {
    if (null != details['user']) {
      var user = details['user'];

      try {
        userInfo = new UserInformation (
          username, password, user['first'], user['last'], user['email'], user['cwid']
        );

        notifyPath ('userInfo', userInfo);

        this.fire ('updated-user-info');
      } catch (_) {}
    }
  }
}
