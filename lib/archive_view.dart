@HtmlImport('archive_view.html')
library plato.elements.view.archive;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_item.dart';

import 'plato_elements_utils.dart';

/// The [ArchiveView] class...
@PolymerRegister('archive-view')
class ArchiveView extends PolymerElement {
  /// The [ArchiveView] factory constructor...
  factory ArchiveView() => document.createElement ('archive-view');

  /// The [ArchiveView] named constructor...
  ArchiveView.created() : super.created();

  /// The [attached] method...
  void attached();
}
