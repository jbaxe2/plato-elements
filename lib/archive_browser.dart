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

/// Silence analyzer:
/// [IronSignals]
/// [PaperButton] - [PaperDialog] - [PaperMaterial]
///
/// The [ArchiveBrowser] class...
@PolymerRegister('archive-browser')
class ArchiveBrowser extends PolymerElement {
  @Property(notify: true)
  String archiveId;

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

    _archivePuller = $['archive-puller-ajax'] as IronAjax;
    _browserDialog = $['browse-archive-dialog'] as PaperDialog;
  }

  /// The [onBrowseArchive] method...
  @Listen('iron-signal-browse-archive')
  void onBrowseArchive (CustomEvent event, details) {
    window.console.log ('made it to on browse archive, for iron signal.');

    if (null != details['archiveId']) {
      String archiveId = details['archiveId'];
      String termId = archiveId.split ('_').last;

      _archivePuller
        ..params = {'archiveId': archiveId, 'termId': termId}
        ..generateRequest();

      _browserDialog.open();

      this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});
    }
  }

  /// The [onArchivePulled] method...
  @Listen('response')
  void onArchivePulled (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    window.console.log ('Received a response for pulling the archive...');

    if (null != details['pulled']) {
      set ('archiveLoaded', true);
    }
  }
}
