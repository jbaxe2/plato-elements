// Copyright (c) 2016-2017, Joseph B. Axenroth. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

library plato.elements;

import 'package:polymer/polymer.dart';

import '../lib/course_request.dart';

import '../lib/plato_element_error.dart';
import '../lib/plato_element_processing.dart';

import '../lib/session_cleanup.dart';

/// Silence analyzer:
/// [PlatoElementError] - [PlatoElementProcessing] - [SessionCleanup]
///
/// [CourseRequest]
///
/// The [main] function (entry-point into application).
main() async => await initPolymer();
