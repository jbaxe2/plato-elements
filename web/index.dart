// Copyright (c) 2016, Joseph B. Axenroth. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

library plato.elements;

import 'package:polymer/polymer.dart';

/// Import the custom Plato elements created using Polymer Dart.
import '../lib/learn_authenticator.dart';
import '../lib/learn_authentication_view.dart';
import '../lib/learn_authentication_widget.dart';
import '../lib/user_information_view.dart';

import '../lib/courses_collection.dart';
import '../lib/departments_collection.dart';
import '../lib/sections_collection.dart';
import '../lib/terms_collection.dart';

import '../lib/course_selector.dart';
import '../lib/department_selector.dart';
import '../lib/sections_selector.dart';
import '../lib/term_selector.dart';

import '../lib/section_views_collection.dart';

import '../lib/previous_content_selector.dart';

import '../lib/plato_element_error.dart';
import '../lib/plato_element_processing.dart';

/// Silence analyzer:
/// [LearnAuthenticator] - [LearnAuthenticationView] - [LearnAuthenticationWidget]
/// [UserInformationView]
///
/// [DepartmentsCollection] - [TermsCollection] - [CoursesCollection]
/// [SectionsCollection]
///
/// [DepartmentSelector] - [TermSelector] - [CourseSelector] - [SectionsSelector]
///
/// [SectionViewsCollection]
///
/// [PreviousContentSelector]
///
/// [PlatoElementError] - [PlatoElementProcessing]
///
/// The [main] function (entry-point into application).
main() async => await initPolymer();
