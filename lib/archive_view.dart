@HtmlImport('archive_view.html')
library plato.elements.view.archive;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

import 'package:polymer_elements/paper_item.dart';

import 'plato_elements_utils.dart';

/// The [ArchiveView] class...
@PolymerRegister('archive-view')
class ArchiveView extends PolymerElement {
  @Property(notify: true)
  String archiveId;

  @Property(notify: true)
  String resourceId;

  @Property(notify: true)
  String courseTitle;

  IronAjax _browseAjax;

  /// The [ArchiveView] factory constructor...
  factory ArchiveView() => document.createElement ('archive-view');

  /// The [ArchiveView] named constructor...
  ArchiveView.created() : super.created();

  /// The [attached] method...
  void attached() {
    set ('resourceId', 'none');

    _browseAjax = $['browse-archive-ajax'] as IronAjax
      ..generateRequest();

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});
  }

  /// The [onViewArchive] method...
  @Listen('on-response')
  void onViewArchive (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});
  }
}
