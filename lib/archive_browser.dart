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

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

import 'archive_view.dart';

import 'plato_elements_utils.dart';

/// Silence analyzer:
/// [IronSignals]
/// [PaperButton] - [PaperDialog] - [PaperMaterial]
/// [FadeInAnimation] - [FadeOutAnimation]
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

      this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': {
        'message': 'Loading the course archive; this may take a few minutes for larger courses.'
      }});
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
      _refreshDialog();

      set ('archiveLoaded', true);
      set ('archiveId', response['pulled']);

      this.fire ('browse-archive',
        detail: {'archiveId': archiveId},
        node: querySelector ('archive-view')
      );
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

  /// The [onRefreshArchiveView] method...
  @Listen('refresh-archive-view')
  void onRefreshArchiveView (CustomEvent event, details) => _refreshDialog();

  /// The [_refreshDialog] method...
  void _refreshDialog() {
    _browserDialog
      ..refit()
      ..center()
      ..open();
  }
}
