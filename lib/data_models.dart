library plato.elements.data_models;

import 'package:polymer/polymer.dart';

////////////////////////////////////////////////////////////////////////////////

/// The [BannerCourse] class...
class BannerCourse extends JsProxy {
  @reflectable
  String courseId;

  @reflectable
  String courseTitle;

  /// The [BannerCourse] constructor.
  BannerCourse (this.courseId, this.courseTitle);
}

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////

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

  /// The [isDay] method...
  bool isDay() {
    String digitStr = sectionId.substring (
      (sectionId.length - 3), (sectionId.length - 2)
    );

    // Dual enrollment, and DGCE sections for Day division cross-registration.
    if (('R' == digitStr) || ('E' == digitStr)) {
      return false;
    }

    // Day division honors courses, and whatever a 'P' section refers to.
    if (('H' == digitStr) || ('P' == digitStr)) {
      return true;
    }

    try {
      return (5 == int.parse (digitStr)) ? false : true;
    } catch (e) {}

    // If it is indeterminable that the course is Day, default to false.
    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////

/// The [CrossListing] class...
class CrossListing extends JsProxy {
  @reflectable
  List<BannerSection> sections;

  @reflectable
  bool isValid;

  /// The [CrossListing] constructor...
  CrossListing() {
    sections = new List<BannerSection>();
    isValid = false;
  }

  @reflectable
  bool isCrossListableWith (BannerSection section) {
    if (sections.isEmpty) {
      return true;
    }

    if ((sections.first.isDay() && section.isDay()) ||
        !(sections.first.isDay() || section.isDay())) {
      return true;
    }

    return false;
  }

  @reflectable
  /// The [addSection] method...
  void addSection (BannerSection section) {
    if (!sections.contains (section) && isCrossListableWith (section)) {
      sections.add (section);

      if (1 < sections.length) {
        isValid = true;
      }
    }
  }

  @reflectable
  /// The [removeSection] method...
  void removeSection (BannerSection section) {
    if (sections.contains (section)) {
      sections.remove (section);

      if (2 > sections.length) {
        isValid = false;
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////

/// The [PreviousContentMapping] class...
class PreviousContentMapping extends JsProxy {
  @reflectable
  BannerSection section;

  @reflectable
  CourseEnrollment courseEnrollment;

  /// The [PreviousContentMapping] constructor...
  PreviousContentMapping();
}

////////////////////////////////////////////////////////////////////////////////

/// The [RequestedSection] class provides the data model for a requested course.
/// Underlying aspects of the model includes a [BannerSection] instance, and
/// attaches the potential for previous content (via [PreviousContentMapping])
/// and inclusion in a cross-listing set (via [CrossListing]).
class RequestedSection extends JsProxy {
  @reflectable
  BannerSection get section => _section;

  BannerSection _section;

  @reflectable
  bool hasCrossListing;

  @reflectable
  CrossListing get crossListing => _crossListing;

  CrossListing _crossListing;

  @reflectable
  bool hasPreviousContent;

  @reflectable
  PreviousContentMapping get previousContent => _previousContent;

  PreviousContentMapping _previousContent;

  _RequestedSectionsRegistry _requestedSections;

  /// The [RequestedSection] constructor...
  RequestedSection (BannerSection aSection) {
    _section = aSection;

    hasCrossListing = false;
    hasPreviousContent = false;

    _requestedSections = new _RequestedSectionsRegistry()
      ..addRequestedSection (this);
  }

  /// The [setSection] method...
  void setSection (BannerSection aSection) {
    _section = aSection;
    _requestedSections.addRequestedSection (this);

    _crossListing = null;
    _previousContent = null;

    hasCrossListing = false;
    hasPreviousContent = false;
  }

  /// The [setPreviousContent] method...
  bool setPreviousContent (PreviousContentMapping aPreviousContent) {
    if (aPreviousContent?.section != section) {
      return false;
    }

    if (_requestedSections.canUsePreviousContent (this, aPreviousContent)) {
      _previousContent = aPreviousContent;
      hasPreviousContent = true;

      return true;
    }

    return false;
  }

  /// The [setCrossListing] method...
  bool setCrossListing (CrossListing aCrossListing) {
    if (!aCrossListing.sections.contains (section)) {
      return false;
    }

    if (_requestedSections.canUseCrossListing (this, aCrossListing)) {
      _crossListing = aCrossListing;
      hasCrossListing = true;

      return true;
    }

    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////

/// The [_RequestedSectionsRegistry] class is an internal (to the library)
/// representation of the courses that have been requested during a particular
/// use of the course request form.
class _RequestedSectionsRegistry extends JsProxy {
  static _RequestedSectionsRegistry _instance;

  @reflectable
  List<RequestedSection> get requestedSections => _requestedSections;

  List<RequestedSection> _requestedSections;

  /// The [_RequestedSectionsRegistry] constructor...
  factory _RequestedSectionsRegistry() {
    return _instance ??= new _RequestedSectionsRegistry._internal();
  }

  _RequestedSectionsRegistry._internal() {
    _requestedSections = new List<RequestedSection>();
  }

  /// The [addRequestedSection] method...
  void addRequestedSection (RequestedSection requestedSection) {
    if (null != requestedSection) {
      requestedSections.add (requestedSection);
    }
  }

  /// The [removeRequestedSection] method...
  bool removeRequestedSection (RequestedSection requestedSection) {
    return requestedSections.remove (requestedSection);
  }

  /// The [canUsePreviousContent] method...
  bool canUsePreviousContent (RequestedSection forSection, PreviousContentMapping previousContent) {
    if (!forSection.hasCrossListing) {
      return true;
    }

    if (requestedSections.contains (forSection)) {
      List<RequestedSection> requestedList = requestedSections.where (
        (requestedSection) => requestedSection.crossListing == forSection.crossListing
      ).toList();

      if (requestedList.any ((requested) => requested.hasPreviousContent)) {
        if (requestedList.every ((pcRequested) => pcRequested.previousContent == previousContent)) {
          return true;
        }
      } else {
        return true;
      }
    }

    return false;
  }

  /// The [canUseCrossListing] method...
  bool canUseCrossListing (RequestedSection forSection, CrossListing crossListing) {
    if (!forSection.hasPreviousContent) {
      return true;
    }

    if (requestedSections.contains (forSection)) {
      List<RequestedSection> requestedList = requestedSections.where (
        (requestedSection) => requestedSection.crossListing == crossListing
      ).toList();

      if ((0 == requestedList.length) || (1 == requestedList.length)) {
        return true;
      }

      if (1 < requestedList.length) {
        var pcRequested = requestedList.first.previousContent;

        if (requestedList.every ((requested) => requested.previousContent == pcRequested)) {
          return true;
        }
      }
    }

    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////
