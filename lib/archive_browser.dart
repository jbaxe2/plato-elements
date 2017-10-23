@HtmlImport('archive_browser.html')
library plato.elements.browser.archive;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_material.dart';

import 'archive_view.dart';

import 'plato_elements_utils.dart';

/// Silence analyzer:
/// [IronSignals]
/// [PaperButton] - [PaperDialog] - [PaperMaterial]
/// [ArchiveView]
///
/// The [ArchiveBrowser] class...
@PolymerRegister('archive-browser')
class ArchiveBrowser extends PolymerElement {
  @Property(notify: true)
  String archiveId;

  @Property(notify: true)
  String archiveTerm;

  @Property(notify: true)
  bool archiveLoaded;

  IronAjax _archivePuller;

  PaperDialog _browserDialog;

  /// The [ArchiveBrowser] factory constructor...
  factory ArchiveBrowser() => document.createElement ('archive-browser');

  /// The [ArchiveBrowser] named constructor...
  ArchiveBrowser.created() : super.created();

  /// The [attached] method...
  void attached() {
    set ('archiveLoaded', false);

    _archivePuller = $['pull-archive-ajax'] as IronAjax;
    _browserDialog = $['browse-archive-dialog'] as PaperDialog;
  }

  /// The [onBrowseArchive] method...
  @Listen('iron-signal-browse-archive')
  void onBrowseArchive (CustomEvent event, details) {
    if (null != details['archiveId']) {
      set ('archiveId', details['archiveId']);
      set ('archiveTerm', archiveId.split ('_').last);

      _archivePuller
        ..params = {'archiveId': archiveId, 'archiveTerm': archiveTerm}
        ..generateRequest();

      this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});
    }
  }

  /// The [onArchivePulled] method...
  @Listen('response')
  void onArchivePulled (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    var response = _archivePuller.lastResponse;

    if (null != response['error']) {
      raiseError (this, 'Archive pull error', response['error']);
    } else if (null != response['pulled']) {
      set ('archiveLoaded', true);
      _browserDialog.open();
    }
  }

  /// The [onArchiveReviewed] method...
  @Listen('tap')
  void onArchiveReviewed (CustomEvent event, details) {
    if ('archive-reviewed-button' == (Polymer.dom (event)).localTarget.id) {
      _browserDialog.close();
      set ('archiveLoaded', false);
    }
  }
}
