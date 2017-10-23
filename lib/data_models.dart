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
  @reflectable
  bool isDay() {
    String digitStr = sectionId.substring (
      (sectionId.length - 3), (sectionId.length - 2)
    );

    // Dual enrollment, and DGCE sections for Day division cross-registration.
    if (('R' == digitStr) || ('E' == digitStr) ||
        ('H' == digitStr) || ('P' == digitStr)) {
      return true;
    }

    try {
      return (5 == int.parse (digitStr)) ? false : true;
    } catch (e) {}

    // If it is indeterminable that the course is Day, default to false.
    return false;
  }

  /// The '==' operator for determining equivalency (NOT necessarily identicality)
  /// between two different [BannerSection] instances.
  @override
  bool operator ==(BannerSection other) {
    if ((other.sectionId == sectionId) &&
        (other.crn == crn) &&
        (other.courseTitle == courseTitle) &&
        (other.faculty == faculty) &&
        (other.time == time) &&
        (other.place == place) &&
        (other.termId == termId)) {
      return true;
    }

    return false;
  }

  /// The hashCode getter, which must be overridden whenever the '==' operator is.
  @override
  int get hashCode {
    int result = 3;

    result = 7 * result + ((null == sectionId) ? 0 : sectionId.hashCode);
    result = 7 * result + ((null == crn) ? 0 : crn.hashCode);
    result = 7 * result + ((null == courseTitle) ? 0 : courseTitle.hashCode);
    result = 7 * result + ((null == faculty) ? 0 : faculty.hashCode);
    result = 7 * result + ((null == time) ? 0 : time.hashCode);
    result = 7 * result + ((null == place) ? 0 : place.hashCode);
    result = 7 * result + ((null == termId) ? 0 : termId.hashCode);

    return result;
  }

  Map toJson() {
    return {
      'sectionId': sectionId,
      'crn': crn,
      'courseTitle': courseTitle,
      'faculty': faculty,
      'time': time,
      'place': place,
      'termId': termId
    };
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

  @reflectable
  bool isArchive;

  /// The [CourseEnrollment] constructor...
  CourseEnrollment (
    this.username, this.courseId, this.courseName, this.role, this.available,
    {this.isArchive: false}
  );

  /// The '==' operator for determining equivalency (NOT necessarily identicality)
  /// between two different [CourseEnrollment] instances.
  @override
  bool operator ==(CourseEnrollment other) {
    if ((other.username == username) &&
        (other.courseId == courseId) &&
        (other.courseName == courseName) &&
        (other.role == role) &&
        (other.available == available) &&
        (other.isArchive == isArchive)) {
      return true;
    };

    return false;
  }

  /// The hashCode getter, which must be overridden whenever the '==' operator is.
  @override
  int get hashCode {
    int result = 3;

    result = 7 * result + ((null == username) ? 0 : username.hashCode);
    result = 7 * result + ((null == courseId) ? 0 : courseId.hashCode);
    result = 7 * result + ((null == courseName) ? 0 : courseName.hashCode);
    result = 7 * result + ((null == role) ? 0 : role.hashCode);
    result = 7 * result + ((null == available) ? 0 : available.hashCode);
    result = 7 * result + ((null == isArchive) ? 0 : isArchive.hashCode);

    return result;
  }

  Map toJson() {
    return {
      'username': username,
      'courseId': courseId,
      'courseName': courseName,
      'role': role,
      'available': available,
      'isArchive': isArchive
    };
  }
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

  /// The '==' operator for determining equivalency (NOT necessarily identicality)
  /// between two (potentially) different [CrossListing] instances.
  @override
  bool operator ==(CrossListing other) {
    if (identical (other, this)) {
      return true;
    }

    List<BannerSection> oSections = other.sections;

    try {
      if ((oSections.every ((oSection) => sections.contains (oSection))) &&
          (sections.every ((section) => oSections.contains (section)))) {
        return true;
      }
    } catch (_) {}

    return false;
  }

  /// The hashCode getter, which must be overridden whenever the '==' operator is.
  @override
  int get hashCode {
    int result = 3;

    sections.forEach (
      (BannerSection section) => result = 7 * result + section.hashCode
    );

    return result;
  }

  Map toJson() {
    return {
      'sections': sections,
      'isValid': isValid
    };
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

  /// The '==' operator for determining equivalency (NOT necessarily identicality)
  /// between two different [PreviousContentMapping] instances.
  @override
  bool operator ==(PreviousContentMapping other) => (
    (other.section == section) && (other.courseEnrollment == courseEnrollment)
  );

  /// The hashCode getter, which must be overridden whenever the '==' operator is.
  @override
  int get hashCode {
    int result = 3;

    result = 7 * result + section.hashCode;
    result = 7 * result + courseEnrollment.hashCode;

    return result;
  }

  Map toJson() {
    return {
      'section': section,
      'courseEnrollment': courseEnrollment
    };
  }
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
  CrossListing get crossListing => _crossListing;

  CrossListing _crossListing;

  @reflectable
  bool hasCrossListing;

  @reflectable
  PreviousContentMapping get previousContent => _previousContent;

  PreviousContentMapping _previousContent;

  @reflectable
  bool hasPreviousContent;

  _RequestedSectionsRegistry _requestedSections;

  /// The [RequestedSection] constructor creates the requested section instance,
  /// but also initializes the cross-listing and previous content information.
  /// This requested section is also added to the requested sections registry.
  RequestedSection (BannerSection aSection) {
    if (null != aSection) {
      setSection (aSection);

      _requestedSections = new _RequestedSectionsRegistry()
        ..addRequestedSection (this);
    }
  }

  /// The [setSection] method allows for the setting of a different [BannerSection]
  /// instance.  As a result, the cross-listing and previous content will become
  /// nullified, as those properties were specifically tied to the previous
  /// section instance.
  @reflectable
  void setSection (BannerSection aSection) {
    if (null != aSection) {
      _section = aSection;

      _crossListing = null;
      _previousContent = null;

      hasCrossListing = false;
      hasPreviousContent = false;
    }
  }

  /// The [canUsePreviousContent] method...
  @reflectable
  bool canUsePreviousContent (PreviousContentMapping aPreviousContent) =>
    _requestedSections.canUsePreviousContent (this, aPreviousContent);

  /// The [setPreviousContent] method attempts to attach a [PreviousContentMapping]
  /// instance to the underlying [BannerSection] instance.  This method will return
  /// true if the mapping is successful, or false on any error.
  @reflectable
  bool setPreviousContent (PreviousContentMapping aPreviousContent) {
    if ((null == aPreviousContent) || (aPreviousContent.section != section) ||
        !_requestedSections.canUsePreviousContent (this, aPreviousContent)) {
      return false;
    }

    _previousContent = aPreviousContent;
    hasPreviousContent = true;

    return true;
  }

  /// The [removePreviousContent] method...
  @reflectable
  PreviousContentMapping removePreviousContent() {
    PreviousContentMapping thePreviousContent = previousContent;

    if (null != previousContent) {
      _previousContent = null;
      hasPreviousContent = false;
    };

    return thePreviousContent;
  }

  /// The [canUseCrossListing] method...
  @reflectable
  bool canUseCrossListing (CrossListing aCrossListing) =>
    _requestedSections.canUseCrossListing (this, aCrossListing);

  /// The [setCrossListing] method attempts to attach a [CrossListing] instance
  /// to the underlying [BannerSection] instance.  If the cross-listing set can
  /// contain the [BannerSection], the method will return true.  False will be
  /// returned if the cross-listing set cannot add the section.
  @reflectable
  bool setCrossListing (CrossListing aCrossListing) {
    if ((null == aCrossListing) ||
        !_requestedSections.canUseCrossListing (this, aCrossListing)) {
      return false;
    }

    _crossListing = aCrossListing;
    hasCrossListing = true;

    return true;
  }

  /// The [removeCrossListing] method...
  @reflectable
  CrossListing removeCrossListing() {
    CrossListing theCrossListing;

    if (null != _crossListing) {
      _crossListing.removeSection (section);
    }

    theCrossListing = _crossListing;
    _crossListing = null;
    hasCrossListing = false;

    return theCrossListing;
  }

  /// The '==' operator for determining loose equivalency (NOT necessarily
  /// equality nor identicality) between two different [RequestedSection]
  /// instances.  Loose equivalency is based on equality just between sections.
  @override
  bool operator ==(RequestedSection other) {
    if (other.section == section) {
      return true;
    }

    return false;
  }

  /// The [isStrictlyEquivTo] method is used to determine strict equivalency
  /// (NOT necessarily identicality) between two different [RequestedSection]
  /// instances.  Strict equivalency is based on equality between the underlying
  /// sections, cross-listing sets, and previous content mappings.
  bool isStrictlyEquivTo (RequestedSection other) {
    if ((other.section == section) &&
        (other.crossListing == crossListing) &&
        (other.previousContent == previousContent)) {
      return true;
    }

    return false;
  }

  /// The hashCode getter, which must be overridden whenever the '==' operator is.
  @override
  int get hashCode {
    int result = 3;

    result = 7 * result + section.hashCode;
    result = 7 * result + crossListing.hashCode;
    result = 7 * result + previousContent.hashCode;

    return result;
  }

  Map toJson() {
    return {
      'section': section,
      'crossListing': crossListing,
      'previousContent': previousContent
    };
  }
}

////////////////////////////////////////////////////////////////////////////////

/// The [_RequestedSectionsRegistry] class is an internal (to the library)
/// representation of the courses that have been requested during a particular
/// use of the course request form.
class _RequestedSectionsRegistry extends JsProxy {
  static _RequestedSectionsRegistry _instance;

  static List<RequestedSection> _requestedSections;

  @reflectable
  List<RequestedSection> get requestedSections => _requestedSections;

  /// The [_RequestedSectionsRegistry] constructor...
  factory _RequestedSectionsRegistry() {
    return _instance ??= new _RequestedSectionsRegistry._internal();
  }

  /// The [_RequestedSectionsRegistry] internal named constructor...
  _RequestedSectionsRegistry._internal() {
    _requestedSections = new List<RequestedSection>();
  }

  /// The [addRequestedSection] method...
  @reflectable
  void addRequestedSection (RequestedSection requestedSection) {
    if ((null != requestedSection) && !requestedSections.contains (requestedSection)) {
      if (requestedSections.every (
        (aRequestedSection) => (requestedSection != aRequestedSection) ? true : false
      )) {
        requestedSections.add (requestedSection);
      }
    }
  }

  /// The [removeRequestedSection] method...
  @reflectable
  bool removeRequestedSection (RequestedSection requestedSection) {
    if (null != requestedSection) {
      requestedSection
        ..removePreviousContent()
        ..removeCrossListing();

      return requestedSections.remove (requestedSection);
    }

    return false;
  }

  /// The [canUsePreviousContent] method...
  @reflectable
  bool canUsePreviousContent (RequestedSection forSection, PreviousContentMapping previousContent) {
    if (!forSection.hasCrossListing) {
      return true;
    }

    if (requestedSections.contains (forSection)) {
      List<RequestedSection> requestedList = requestedSections.where (
        (requestedSection) => requestedSection.crossListing == forSection.crossListing
      ).toList();

      if (requestedList.isEmpty) {
        return true;
      }

      if (requestedList.any ((requested) => requested.hasPreviousContent)) {
        if (requestedList.every ((RequestedSection pcRequested) {
          if ((null == pcRequested.previousContent) ||
              (pcRequested.previousContent.courseEnrollment == previousContent.courseEnrollment)) {
            return true;
          }

          return false;
        })) {
          return true;
        }
      } else {
        return true;
      }
    }

    return false;
  }

  /// The [canUseCrossListing] method...
  @reflectable
  bool canUseCrossListing (RequestedSection forSection, CrossListing crossListing) {
    if (!crossListing.isCrossListableWith (forSection.section)) {
      return false;
    }

    if (!forSection.hasPreviousContent) {
      return true;
    }

    List<RequestedSection> clReqSections = requestedSections.where (
      (RequestedSection reqSection) => crossListing.sections.contains (reqSection.section)
    );

    if (crossListing.sections.every ((BannerSection clSection) {
      if (clReqSections.every ((RequestedSection clReqSection) {
        if (!clReqSection.hasPreviousContent) {
          return true;
        }

        if (clReqSection.section == clSection) {
          return true;
        } else {
          if (!clReqSection.hasCrossListing) {
            return true;
          }
        }

        if (clReqSection.previousContent.courseEnrollment.courseId ==
            forSection.previousContent.courseEnrollment.courseId) {
          return true;
        }

        return false;
      })) {
        return true;
      }

      if (getRequestedSection (clSection).previousContent.courseEnrollment.courseId ==
          forSection.previousContent.courseEnrollment.courseId) {
        return true;
      }

      return false;
    })) {
      return true;
    }

    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////

/// The [ArchiveItem] class...
class ArchiveItem extends JsProxy {
  @reflectable
  String resourceId;

  @reflectable
  String title;

  @reflectable
  List<ArchiveItem> items;

  /// The [ArchiveItem] default constructor...
  ArchiveItem (this.resourceId, this.title) {
    items = new List<ArchiveItem>();
  }
}

////////////////////////////////////////////////////////////////////////////////

/// The [RejectedCourse] class...
class RejectedCourse extends JsProxy {
  @reflectable
  String id;

  @reflectable
  String title;

  /// The [RejectedCourse] default constructor.
  RejectedCourse (this.id, this.title);

  /// The [RejectedCourse] named constructor.
  RejectedCourse.fromMap (Map<String, String> rejectedCourse) {
    try {
      id = rejectedCourse['id'];
      title = rejectedCourse['title'];
    } catch (_) {}
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

  /// The [toJson] method...
  Map toJson() {
    return {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'cwid': cwid
    };
  }
}

////////////////////////////////////////////////////////////////////////////////

/// The [getRequestedSection] function...
RequestedSection getRequestedSection (BannerSection section) {
  RequestedSection requestedSection;

  (new _RequestedSectionsRegistry()).requestedSections.any (
    (RequestedSection reqSection) {
      if (section == reqSection.section) {
        requestedSection = reqSection;

        return true;
      }

      return false;
    }
  );

  return requestedSection;
}

/// The [removeRequestedSection] function...
bool removeRequestedSection (RequestedSection requestedSection) =>
  (new _RequestedSectionsRegistry()).removeRequestedSection (requestedSection);

////////////////////////////////////////////////////////////////////////////////
