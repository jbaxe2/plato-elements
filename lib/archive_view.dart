@HtmlImport('archive_view.html')
library plato.elements.view.archive;

import 'dart:html';
import 'dart:js';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/paper_submenu.dart';

import 'data_models.dart' show ArchiveItem;
import 'plato_elements_utils.dart';

/// Silence analyzer:
/// [PaperItem] - [PaperMenu] - [PaperSubmenu]
///
/// The [ArchiveView] class...
@PolymerRegister('archive-view')
class ArchiveView extends PolymerElement {
  @Property(notify: true)
  String archiveId;

  @Property(notify: true)
  String resourceId;

  @Property(notify: true)
  String courseTitle;

  Map<String, Map> _manifestOutline;

  @Property(notify: true)
  List<ArchiveItem> manifestItems;

  IronAjax _browseAjax;

  /// The [ArchiveView] factory constructor...
  factory ArchiveView() => document.createElement ('archive-view');

  /// The [ArchiveView] named constructor...
  ArchiveView.created() : super.created();

  /// The [attached] method...
  void attached() {
    _manifestOutline = new Map<String, Map>();

    set ('resourceId', 'none');
    set ('manifestItems', new List<ArchiveItem>());

    _browseAjax = $['browse-archive-ajax'] as IronAjax
      ..generateRequest();

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});
  }

  /// The [onViewArchive] method...
  @Listen('on-response')
  void onViewArchive (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    var response = _browseAjax.lastResponse;

    if ((null != response['error']) ||
        (null == response['courseId']) || (null == response['courseTitle'])) {
      raiseError (this, 'Browsing archive error', response['error']);
      return;
    }

    set ('archiveId', response['courseId']);
    set ('courseTitle', response['courseTitle']);

    if (null != response['manifestOutline']) {
      _manifestOutline = convertToDart (response['manifestOutline'] as JsObject);
      _handleManifestOutline (_manifestOutline);
    }
  }

  /// The [_handleManifestOutline] method...
  void _handleManifestOutline (Map<String, Map> outline) {
    async (() {
      outline.forEach ((String aResourceId, Map anItem) {
        if ((anItem[aResourceId] as String).contains ('divider')) {
          anItem[aResourceId] = '------------------------------------------';
        }

        var archiveItem = new ArchiveItem (aResourceId, anItem[aResourceId]);

        anItem.forEach ((subResourceId, subItem) {
          if (!(subItem is String)) {
            archiveItem.items.add (
              new ArchiveItem (subResourceId, subItem[subResourceId])
            );
          }
        });

        add ('manifestItems', archiveItem);
      });

      this.fire ('resize-archive-view');
    });
  }
}
