@HtmlImport('test_element.html')
library plato_elements.lib.test_element;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

@PolymerRegister('test-element')
class TestElement extends PolymerElement {
  @Property(notify: true)
  String value;

  /// The [TestElement] factory constructor.
  factory TestElement() => document.createElement ('test-element');

  /// The [TestElement] named constructor.
  TestElement.created() : super.created();

  /// The [ready] method...
  void ready() {
    ;
  }
}
