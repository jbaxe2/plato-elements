// Copyright (c) 2016, Joseph B. Axenroth. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

library plato_elements;

import 'package:polymer/polymer.dart';

/// Import the custom Plato elements created using Polymer Dart.
import '../lib/learn_authenticator.dart';

import '../lib/departments_collection.dart';
import '../lib/terms_collection.dart';
import '../lib/courses_collection.dart';
import '../lib/sections_collection.dart';

import '../lib/courses_selector.dart';
import '../lib/departments_selector.dart';
import '../lib/terms_selector.dart';

/// Silence analyzer:
/// [LearnAuthenticator] - [DepartmentsCollection] - [TermsCollection]
/// [CoursesCollection] - [SectionsCollection]
/// [DepartmentsSelector] - [TermsSelector] - [CoursesSelector]

/// The [main] function (entry-point into application).
main() async => await initPolymer();
