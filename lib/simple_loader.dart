@HtmlImport('simple_loader.html')
library plato_elements.simple_loader;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

/// The [SimpleLoader] class...
@PolymerRegister('simple-loader')
class SimpleLoader extends PolymerElement {
  /// The type of loader, to be configured by elements using an instance of this
  /// element in aggregate.
  @Property(notify: true)
  String type;

  /// The [IronAjax] instance for loading some data from the server.
  IronAjax _loaderAjax;

  /// The [SimpleLoader] factory constructor...
  factory SimpleLoader() => document.createElement ('simple-loader');

  /// The [SimpleLoader] named constructor...
  SimpleLoader.created() : super.created();

  /// The [loadTypedData] method...
  void loadTypedData() {
    (_loaderAjax ??= $['loader-ajax'] as IronAjax)
      ..contentType = 'application/x-www-form-urlencoded'
      ..generateRequest();
  }

  /// The [handleLoadResponse] method...
  @Listen('response')
  void handleLoadResponse (event, details) {
    this.fire ('loaded-${type.toLowerCase()}', detail: details);
  }
}
