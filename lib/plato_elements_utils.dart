library plato.elements.utils;

import 'package:polymer/polymer.dart';

////////////////////////////////////////////////////////////////////////////////

/// The [raiseError] function...
void raiseError (PolymerElement forElement, String title, String message) {
  title ??= 'Error!';
  message ??= 'An unknown error has occurred.';

  forElement ??= new PolymerElement.created();

  forElement.fire (
    'iron-signal',
    detail: {
      'name': 'error',
      'data': {
        'error': {
          'title': title,
          'message': message
        }
      }
    }
  );
}

////////////////////////////////////////////////////////////////////////////////
