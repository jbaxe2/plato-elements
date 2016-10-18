library plato.elements.data_models;

import 'package:polymer/polymer.dart';

/////////////////////////////////////////////////////////////////////

/// The [BannerCourse] class...
class BannerCourse extends JsProxy {
  @reflectable
  String courseId;

  @reflectable
  String courseTitle;

  /// The [BannerCourse] constructor.
  BannerCourse (this.courseId, this.courseTitle);
}

/////////////////////////////////////////////////////////////////////

/// The [BannerDepartment] class...
class BannerDepartment extends JsProxy {
  /// The 3 or 4 letter code for the department.
  @reflectable
  String code;

  /// The name or description of the department.
  @reflectable
  String description;

  /// The [BannerDepartment] constructor.
  BannerDepartment (this.code, this.description);
}

/////////////////////////////////////////////////////////////////////

/// The [BannerSection] class...
class BannerSection extends JsProxy {
  @reflectable
  String sectionId;

  @reflectable
  String crn;

  @reflectable
  String courseTitle;

  @reflectable
  String faculty;

  @reflectable
  String time;

  @reflectable
  String place;

  @reflectable
  String termId;

  /// The [BannerSection] method...
  BannerSection (
    this.sectionId, this.crn, this.courseTitle, this.faculty,
    this.time, this.place, this.termId
  );
}

/////////////////////////////////////////////////////////////////////

/// The [LearnTerm] class...
class LearnTerm extends JsProxy {
  /// The code or ID of the term.
  @reflectable
  String termId;

  /// The name or description of the term.
  @reflectable
  String description;

  /// The [LearnTerm] constructor.
  LearnTerm (this.termId, this.description);
}

/////////////////////////////////////////////////////////////////////

/// The [CourseEnrollment] class...
class CourseEnrollment extends JsProxy {
  @reflectable
  String username;

  @reflectable
  String courseId;

  @reflectable
  String courseName;

  @reflectable
  String role;

  @reflectable
  String available;

  /// The [CourseEnrollment] constructor...
  CourseEnrollment (
    this.username, this.courseId, this.courseName, this.role, this.available
  );
}

/////////////////////////////////////////////////////////////////////

/// The [CourseRequest] class...
class CourseRequest extends JsProxy {
  @reflectable
  UserInformation userInfo;

  @reflectable
  List<BannerSection> sections;

  @reflectable
  List<CrossListing> crossListings;

  @reflectable
  List<PreviousContentMapping> previousContents;

  /// The [CourseRequest] constructor...
  CourseRequest() {
    sections = new List<BannerSection>();
    crossListings = new List<CrossListing>();
    previousContents = new List<PreviousContentMapping>();
  }
}

/////////////////////////////////////////////////////////////////////

/// The [CrossListing] class...
class CrossListing extends JsProxy {
  @reflectable
  List<BannerSection> sections;

  /// The [CrossListing] constructor...
  CrossListing() {
    sections = new List<BannerSection>();
  }

  @reflectable
  /// The [addSection] method...
  void addSection (BannerSection section) {
    if (!sections.contains (section)) {
      sections.add (section);
    }
  }

  @reflectable
  /// The [removeSection] method...
  void removeSection (BannerSection section) {
    if (sections.contains (section)) {
      sections.remove (section);
    }
  }
}

/////////////////////////////////////////////////////////////////////

/// The [PreviousContentMapping] class...
class PreviousContentMapping extends JsProxy {
  @reflectable
  BannerSection section;

  @reflectable
  CourseEnrollment courseEnrollment;

  /// The [PreviousContentMapping] constructor...
  PreviousContentMapping();
}

/////////////////////////////////////////////////////////////////////

/// The [UserInformation] class...
class UserInformation extends JsProxy {
  @reflectable
  String get username => _username;

  @reflectable
  String get password => _password;

  @reflectable
  String get firstName => _firstName;

  @reflectable
  String get lastName => _lastName;

  @reflectable
  String get email => _email;

  @reflectable
  String get cwid => _cwid;

  String _username, _password, _firstName, _lastName, _email, _cwid;

  /// The [UserInformation] default constructor.
  UserInformation (
    this._username, this._password, this._firstName, this._lastName, this._email, this._cwid
  );
}

/////////////////////////////////////////////////////////////////////
