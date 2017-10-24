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

  IronAjax _resourceAjax;

  @Property(notify: true)
  bool previewResource;

  /// The [ArchiveView] factory constructor...
  factory ArchiveView() => document.createElement ('archive-view');

  /// The [ArchiveView] named constructor...
  ArchiveView.created() : super.created();

  /// The [attached] method...
  void attached() {
    _manifestOutline = new Map<String, Map>();

    set ('resourceId', 'none');
    set ('manifestItems', new List<ArchiveItem>());
    set ('previewResource', false);

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});

    _browseAjax = $['browse-archive-ajax'] as IronAjax
      ..generateRequest();

    _resourceAjax = $['preview-resource-ajax'] as IronAjax;
  }

  /// The [onViewArchive] method...
  @Listen('response')
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
      _handleManifestOutline();
    }
  }

  /// The [_handleManifestOutline] method...
  void _handleManifestOutline() {
    async (() {
      _manifestOutline.forEach ((String aResourceId, Map anItem) {
        if ((anItem[aResourceId] as String).contains ('divider')) {
          anItem[aResourceId] = '------------------------------------------';
        }

        var archiveItem = new ArchiveItem (aResourceId, anItem[aResourceId]);

        anItem.forEach ((subResourceId, subItem) {
          if (subItem is Map) {
            subItem.forEach ((String aSubResourceId, Map aSubItemTitle) {
              archiveItem.items.add (
                new ArchiveItem (aSubResourceId, aSubItemTitle[aSubResourceId])
              );
            });
          }
        });

        add ('manifestItems', archiveItem);
      });

      this.fire ('resize-archive-view');
    });
  }

  /// The [onPreviewResource] method...
  @Listen('tap')
  void onPreviewResource (CustomEvent event, details) {
    var resourceLink = (Polymer.dom (event)).localTarget.id as String;

    if (resourceLink.contains ('-resource-link')) {
      set ('resourceId', resourceLink.split ('-').first);
    }

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});

    _resourceAjax.generateRequest();
  }

  /// The [onPreviewResourceResponse] method...
  @Listen('response')
  void onPreviewResourceResponse (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    var response = _resourceAjax.lastResponse;

    if (null != response['error']) {
      raiseError (this, 'Browsing archive error', response['error']);
      return;
    }

    window.console.log (response);
  }
}
