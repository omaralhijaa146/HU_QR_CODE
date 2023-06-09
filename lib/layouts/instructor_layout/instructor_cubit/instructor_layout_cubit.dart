import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/models/attended_by_class_model/attended_by_class_model.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/models/class_location_model/class_location_model.dart';
import 'package:graduation_project/models/class_room_info_model/class_room_info_model.dart';
import 'package:graduation_project/models/course_info_model/course_info_model.dart';
import 'package:graduation_project/models/instructor_register_model/instructor_register_model.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/models/students_attendance_model/students_attendance_model.dart';
import 'package:graduation_project/modules/check_class_date_time_info/check_class_date_time_info.dart';
import 'package:graduation_project/modules/check_class_id_info/check_class_id_info.dart';
import 'package:graduation_project/modules/class_attendance_list/class_attendence_list.dart';
import 'package:graduation_project/modules/class_attendance_page_view/class_attendance_page_view.dart';
import 'package:graduation_project/modules/class_attendance_repororts/class_attendance_reports.dart';
import 'package:graduation_project/modules/class_info_screen/class_info_screen.dart';
import 'package:graduation_project/modules/class_number_date_info_screen/class_number_date_info_screen.dart';
import 'package:graduation_project/modules/class_room_info_screen/class_room_info_screen.dart';
import 'package:graduation_project/modules/course_info_screen/course_info_screen.dart';
import 'package:graduation_project/modules/edit_class_attendance_screen/edit_class_attendance_screen.dart';
import 'package:graduation_project/modules/get_classes_screen/get_classes_screen.dart';
import 'package:graduation_project/modules/instructor_settings%20Screen/instructor_settings_screen.dart';
import 'package:graduation_project/modules/search_students_screen/search_students_screen.dart';
import 'package:graduation_project/modules/set_range_and_location_screen/set_range_and_location_screen.dart';
import 'package:graduation_project/modules/update_range_and_location_screen/update_range_and_location_screen.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/constatnts/constants.dart';
import 'package:graduation_project/shared/network/local/cache_helper.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import '../../../models/display_classes_model/display_classes_model.dart';
import '../../../modules/navigators/login_navigator.dart';
import 'instructor_layout_states.dart';

class InstructorLayoutCubit extends Cubit<InstructorLayoutStates> {
  InstructorLayoutCubit() : super(InitialInstructorLayoutState());

  static InstructorLayoutCubit get(context) => BlocProvider.of(context);
  List<BottomNavigationBarItem> bottomNavBar = [
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Document),
      label: "Attendance Lists",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Profile),
      label: "Profile",
    ),
  ];
  dynamic contextLayout;
  List<Widget> LayoutScreens = [
    GetClassesScreen(),
    ClassAttendancePageView(),
    InstructorSettingsScreen(),
  ];
  dynamic boardingContext;
  List<Widget> boardingList = [
    CourseInfoScreen(),
    ClassRoomInfoScreen(),
    SetRangeAndLocationScreen(),
    ClassNumberDateInfoScreen(),
    SearchStudentsScreen(),
  ]; //    CheckClassInfoScreen(),
  List<Widget> boardingList2 = [
    ClassInfoScreen(),
    EditClassAttendanceScreen(),
    CheckClassIdInfo(),
    CheckClassDateTimeInfo(),
    UpdateRangeAndLocationScreen(),
  ]; //
  // CheckClassInfoScreen(),
  List<Widget> boardingList3 = [
    ClassAttendanceList(),
    ClassAttendanceReports()
  ];
  List<List> checkDays = [
    ['sunday', false],
    ['monday', false],
    ['tuesday', false],
    ['wednesday', false],
    ['thursday', false]
  ];
  List<AttendedByClassModel> searchResult = [];
  var boardController = PageController();
  var board2Controller = PageController();
  var board3Controller = PageController();
  var board4Controller = PageController();
  InstructorRegisterModel? instructorModel;
  ClassRoomInfoModel? roomInfoModel;
  CourseInfoModel? courseInfoModel;
  List<StudentRegisterModel>? studentsInClass = [];
  StudentRegisterModel? searchResultModel;
  int currentIndex = 0;
  bool isCreateClassLastStep = false;
  double? lat = 0;
  double? long = 0;
  ClassLocationModel? classLocationModel;
  double locationAccuracy = 0;
  Position? position;
  StreamSubscription? subscription;
  late GoogleMapController controller;
  bool added = false;
  String? courseName;
  ClassInfoModel? classInfoModel;
  DisplayClassesModel? displayClassesModel;
  List<DisplayClassesModel> displayClassesList = [];
  List<AttendedByClassModel> classAttendance = [];
  ScreenshotController screenshotController = ScreenshotController();
  var imagePath;

  Future<void> logout(context) async {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: "uId").then((value) {}).then((value) {
        CacheHelper.removeData(key: "userRole");
      });
      navigateAndReplace(context: context, widget: LoginNavigator());
      emit(LogoutSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LogoutErrorState());
    });
    ;
  }

  Future<void> updateInstructorInfo(
      Map<String, dynamic> updatedValues, context) async {
    FirebaseFirestore.instance
        .collection('instructors')
        .doc(instructorModel?.uId)
        .update({
      'firstName': updatedValues['firstName'],
      'middleName': updatedValues['middleName'],
      'lastName': updatedValues['lastName'],
      'email': updatedValues['email'],
    }).then((value) {
      showToast(
          text: 'Info Updated Successfully',
          state: ToastStates.SUCCESS,
          context: context);
    }).catchError((error) {
      showToast(
          text: 'Error While Updating Info',
          state: ToastStates.ERROR,
          context: context);
    });
  }

  Future<pw.Font> getFont() async {
    final customFont =
        await pw.Font.ttf(await rootBundle.load('assets/openSans_regular.ttf'));
    return customFont;
  }

  Future<Future<Uint8List>> generateText(
      String name, List<List<dynamic>> data) async {
    final pdf = pw.Document();
    pw.Font font = await getFont();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        print('PW BUILDER');
        return <pw.Widget>[
          pw.Table.fromTextArray(headers: [
            'Student ID',
            'First Name',
            'Middle Name',
            'Last Name',
            'Absence Days',
            'Attended',
          ], data: data)
        ];
      },
    ));
    return pdf.save() as Future<Uint8List>;
  }

  Future<File> saveDocument({String? name, required pw.Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final dir2 = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  File? file;

  Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAvailableLists() async* {
    yield* FirebaseFirestore.instance
        .collection('attendanceLists')
        .doc(instructorModel?.uId)
        .collection(classInfoModel?.uId as String)
        .snapshots();
  }

  void deleteList(String listUid){
    getAttendanceInClass(classInfoModel?.uId as String).listen((event) {
      event.forEach((element) {
        FirebaseFirestore
            .instance
            .collection('attendanceLists')
            .doc(instructorModel?.uId)
            .collection(classInfoModel?.uId as String)
            .doc(listUid)
            .collection('students')
            .doc(element.studentRegisterModel?.uId).delete();
      });
    });
    FirebaseFirestore
        .instance
        .collection('attendanceLists')
        .doc(instructorModel?.uId)
        .collection(classInfoModel?.uId as String)
        .doc(listUid)
        .delete();
  }

  Future<void> setNewAttendanceList() async {
    String dateNow = DateFormat('yMEd')
        .format(DateTime.now())
        .replaceAll('/', '-')
        .replaceAll(',', '-')
        .replaceAll(' ', '');
    FirebaseFirestore.instance
        .collection('attendanceLists')
        .doc(instructorModel?.uId)
        .collection(classInfoModel?.uId as String)
        .where('classDate', isEqualTo: dateNow)
        .get()
        .then((value) {
      if (value.docs.length > 0 &&
          value.docs[0].data()['classDate'] == dateNow) {
        showToast(
            text: 'List is already exist',
            state: ToastStates.WARNING,
            context: contextLayout);
      } else {
        FirebaseFirestore.instance
            .collection('attendanceLists')
            .doc(instructorModel?.uId)
            .collection(classInfoModel?.uId as String)
            .add({'classDate': dateNow}).then((value1) {
          FirebaseFirestore.instance
              .collection('classes')
              .doc(classInfoModel?.uId)
              .collection('attendedBy')
              .get()
              .then((value) {
            value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .doc(value1.path)
                  .collection('students')
                  .doc(element.data()['uId'])
                  .set(StudentsAttendanceModel(
                          attendedByClassModel:
                              AttendedByClassModel.fromJson(element.data()),
                          attended: false)
                      .toMap());
            });
            showToast(
                text: 'List is added',
                state: ToastStates.SUCCESS,
                context: contextLayout);
          });
        });
      }
    });
  }

  Future<Iterable<StudentsAttendanceModel>> getAttendanceList() async {
    String dateNow = DateFormat('yMEd')
        .format(DateTime.now())
        .replaceAll('/', '-')
        .replaceAll(',', '-')
        .replaceAll(' ', '');
    return await FirebaseFirestore.instance
        .collection('attendanceLists')
        .doc(instructorModel?.uId)
        .collection(classInfoModel?.uId as String)
        .where('classDate', isEqualTo: dateNow)
        .get()
        .then((value) async {
      return await FirebaseFirestore.instance
          .doc(value.docs[0].reference.path)
          .collection('students')
          .get()
          .then((value1) {
        value1.docs.forEach((element) {
          if (element.data()['attended'] == false) {
            FirebaseFirestore.instance
                .collection('classes')
                .doc(classInfoModel?.uId)
                .collection('attendedBy')
                .doc(element.data()['uId'])
                .update({'absenceDays': element.data()['absenceDays'] + 1});
          }
        });
        return value1.docs
            .map((event) => StudentsAttendanceModel.fromJson(event.data()));
      });
    });
  }

  void selectedDaysItems(index) {
    checkDays[index][1] = !checkDays[index][1];
    print(checkDays);
    emit(CheckedDayChangeState());
  }

  Future<bool> getInstructorInfo() async {
    uId = CacheHelper.getData(key: "uId");
    //emit(GetInstructorInfoLoadingState());
    print('NULL MODEL  ${instructorModel == null ? true : false}');
    if (instructorModel != null) return true;
    print('get infodfffffffffffffffffffffffffffffffffffff');
    return FirebaseFirestore.instance
        .collection("instructors")
        .doc(uId)
        .get()
        .then((value) {
      this.instructorModel = InstructorRegisterModel.fromJson(
          value.data() as Map<String, dynamic>);
      return true;
    }).catchError((error) {
      return false;
    });
    /* return instructorModel as InstructorRegisterModel;*/
  }

  Future<void> setClassRoom({
    required String classRoomId,
    required String buildingName,
  }) async {
    roomInfoModel = ClassRoomInfoModel(
        id: classRoomId,
        buildingName: buildingName,
        uId: '$buildingName-$classRoomId');
    emit(SetClassRoomInfoSuccessState());
  }

  void setCourse({
    required String courseId,
    required String courseName,
  }) async {
    courseInfoModel = CourseInfoModel(id: courseId, courseName: courseName);
    emit(SetCourseInfoSuccessState());
  }

  Future<void> setClass({
    required String classNumber,
    required String classStartTime,
    required String classEndTime,
  }) async {
    Colors.primaries[Random().nextInt(Colors.primaries.length)].toString();
    List<int> classColor = [
      Colors.red.value,
      Colors.green.value,
      Colors.purple.value,
      Colors.deepPurple.value,
      Colors.pinkAccent.value,
      Colors.purpleAccent.value,
      Colors.blueAccent.value
    ];
    List<String>? dateInfoModelList = [];
    if (checkDays.isNotEmpty) {
      dateInfoModelList = [];
      checkDays.forEach((element) {
        if (element[1]) {
          dateInfoModelList?.add(element[0]);
        }
      });
      getInstructorInfo().then((value) {
        print(dateInfoModelList?.length);
        classInfoModel = ClassInfoModel(
          classStartTime: classStartTime,
          instructorUid: uId,
          classNumber: classNumber,
          classRoomUid: roomInfoModel?.uId,
          classEndTime: classEndTime,
          days: dateInfoModelList,
          courseId: courseInfoModel?.id,
          classLocationModel: classLocationModel,
          color: classColor[Random().nextInt(classColor.length)],
        );

        FirebaseFirestore.instance
            .collection('classes')
            .add(classInfoModel!.toMap())
            .then((value) {
          classInfoModel?.uId = value.id;
          value.update({'uId': value.id}).then((value) {
            FirebaseFirestore.instance
                .collection('attendanceLists')
                .doc(instructorModel?.uId)
                .set(instructorModel!.toMap())
                .then((value) {
              emit(SetClassInfoSuccessState());
            });
          });
        }).catchError((error) {
          print(error.toString());
          emit(SetClassInfoErrorState());
        });
      });
    }
  }

  Future<void> setClassLocation(int rangeFromUser) async {
    classLocationModel = ClassLocationModel(
      latitude: lat as double,
      longitude: long as double,
      range: rangeFromUser,
    );
    emit(SetClassLocationSuccessState());
  }

  Future<void> getCurrentLocation() async {
    if (permission != null) {
      Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      ).then((value) {
        lat = value.latitude;
        long = value.longitude;
        emit(GetCurrentLocationSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetCurrentLocationErrorState());
      });
    }
  }

  Future<void> getLiveLocation() async {
    if (lat == 0 && long == 0) {
      getCurrentLocation().then((value) async {
        subscription =
            Geolocator.getPositionStream(locationSettings: locationSettings)
                .listen((event) {
          lat = event.latitude;
          long = event.longitude;
          locationAccuracy = event.accuracy;
          emit(GetLiveLocationSuccessState());
        });
      });
    } else {
      subscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((event) {
        lat = event.latitude;
        long = event.longitude;
        print("event.floor   ${event.floor}");
        locationAccuracy = event.accuracy;
        emit(GetLiveLocationSuccessState());
      });
    }
  }

  void updateLatLng(dynamic value) async {
    lat = value.latitude;
    long = value.longitude;
    emit(UpdateCurrentLocationSuccessState());
  }

  Future<void> closeLiveLocation() async {
    subscription?.cancel();
  }

  void addStudentsInClass(
      AttendedByClassModel student, ClassInfoModel classModel) {
    emit(AddStudentsInClassLoadingState());
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classModel.uId)
        .collection('attendedBy')
        .doc(student.studentRegisterModel?.uId)
        .set(student.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('students')
          .doc(student.studentRegisterModel?.uId)
          .collection('attend')
          .doc(classModel.uId)
          .set(classModel.toMap())
          .then((value) {
        emit(AddStudentsInClassSuccessState());
      });
    }).catchError((error) {
      emit(AddStudentsInClassErrorState(error: error.toString()));
    });
  }

  Future<void> removeStudentFromClass(
      String classId, StudentRegisterModel studentRegisterModel) async {
    FirebaseFirestore.instance
        .collection("classes")
        .doc(classId)
        .collection("attendedBy")
        .doc(studentRegisterModel.uId)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('students')
          .doc(studentRegisterModel.uId)
          .collection('attend')
          .doc(classId)
          .delete()
          .then((value) {});
    }).catchError((error) {});
  }

  void searchStudents(String stdUid) {
    FirebaseFirestore.instance
        .collection("students")
        .where("id", isEqualTo: stdUid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        searchResultModel = StudentRegisterModel.fromJson(element.data());
      });
      emit(SearchStudentsSuccessState());
    }).catchError((error) {
      emit(SearchStudentsErrorState(error: error.toString()));
    });
  }

  void changeBottomNavBarState(int index) {
    currentIndex = index;
    emit(BottomNavBarChangeState());
  }

  Future<void> searchForStudents(String searchValue) async {
    emit(SearchStudentsLoadingState());
    if (searchValue != "" && searchValue != " " && searchValue.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("students")
          .where("id", isGreaterThanOrEqualTo: searchValue)
          .where("id", isLessThanOrEqualTo: "$searchValue\uf7ff")
          .snapshots()
          .listen((event) {
        searchResult.clear();
        if (event.docs.isNotEmpty)
          event.docs.forEach((element) {
            searchResult.add(AttendedByClassModel.fromJson(element.data()));
          });
        emit(SearchStudentsSuccessState());
      });
    } else {
      searchResult.clear();
      emit(SearchStudentsSuccessState());
    }
  }

  Stream<String> getCourseName(String courseId) async* {
    yield* FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((event) => event.data()?['courseName']);
  }

  Stream<Iterable<ClassInfoModel>> getClassesInfo() async* {
    yield* FirebaseFirestore.instance
        .collection('classes')
        .where('instructorUid', isEqualTo: instructorModel?.uId)
        .orderBy('courseId')
        .orderBy('classNumber')
        .snapshots()
        .asyncMap((event) async {
      return await event.docs.map((e) {
        return ClassInfoModel.fromJson(e.data());
      });
    });
  }

  Future<void> deleteClass(ClassInfoModel model, context) async {
    FirebaseFirestore.instance
        .collection('classes')
        .doc(model.uId)
        .collection('attendedBy')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        removeStudentFromClass(
            model.uId as String, StudentRegisterModel.fromJson(element.data()));
      });
      FirebaseFirestore.instance
          .collection('attendanceLists')
          .doc(instructorModel?.uId)
          .collection(model.uId as String)
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .doc(element.reference.path)
                .collection('students')
                .get()
                .then((value) {
              value.docs.forEach((element) {
                FirebaseFirestore.instance.doc(element.reference.path).delete();
              });
            });
            FirebaseFirestore.instance.doc(element.reference.path).delete();
          });
        }
      });
      FirebaseFirestore.instance
          .collection('classes')
          .doc(model.uId)
          .delete()
          .then((value) {
        showToast(
            text: 'Class Deleted',
            state: ToastStates.SUCCESS,
            context: context);
      });
    }).catchError((error) {
      showToast(
          text: 'Error While Deleting Class',
          state: ToastStates.ERROR,
          context: context);
    });
  }

  Future<void> updateClassLocation() async {
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classInfoModel?.uId)
        .update({
      "location": classLocationModel?.toMap(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(classInfoModel?.uId)
          .collection('attendedBy')
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('students')
                .doc(element.id)
                .collection('attend')
                .doc(classInfoModel?.uId)
                .update({'location': classLocationModel?.toMap()});
          });
        }
        emit(UpdateClassLocationSuccessState());
      });
    }).catchError((error) {
      print("ERROR IN Location CLASS METHOD*********");
      emit(UpdateClassLocationErrorState());
    });
  }

  /*Future<void> updateAttendanceClassLocation() async {
    FirebaseFirestore.instance
        .collection('classes')
        .doc(displayClassesModel?.classInfoModel?.uId)
        .collection('attendedBy')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('students')
            .doc(element.data()['uId'])
            .collection('attend')
            .doc(displayClassesModel?.classInfoModel?.uId)
            .update({
          "location": classLocationModel?.toMap(),
        });
      });
      emit(UpdateAttendanceClassLocationSuccessState());
    }).catchError((error) {
      print("ERROR IN ATTENDANCE CLASS METHOD*********");
      emit(UpdateAttendanceClassLocationErrorState());
    });
  }*/

  /*Future<void> updateClassTimePeriodDates(
      Map<String, dynamic> updatedValues) async {
    classAttendance = [];
    List<String> dates = [];
    FirebaseFirestore.instance
        .collection('classes')
        .doc(displayClassesModel?.classInfoModel?.uId)
        .collection('attendedBy')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        classAttendance.add(AttendedByClassModel.fromJson(element.data()));
      });
    });
    if (updatedValues.isNotEmpty) {
      if (updatedValues.containsKey('classStartTime') ||
          updatedValues.containsKey('classEndTime') ||
          updatedValues.containsKey('dates')) {
        if (updatedValues['dates'].isNotEmpty) {
          updatedValues['dates'].forEach((element) {
            if (element[1]) {
              dates.add(element[0]);
            }
          });
        }
        FirebaseFirestore.instance
            .collection('classes')
            .doc(displayClassesModel?.classInfoModel?.uId)
            .update({
          'classStartTime': updatedValues['classTime'],
          'classEndTime': updatedValues['classPeriod'],
          'dates': dates.isNotEmpty
              ? dates
              : displayClassesModel?.classInfoModel?.days,
        }).then((value) {
          classAttendance.forEach((element) {
            FirebaseFirestore.instance
                .collection('students')
                .doc(element.studentRegisterModel?.uId)
                .collection('attend')
                .doc(displayClassesModel?.classInfoModel?.uId)
                .update({
              'classStartTime': updatedValues['classStartTime'],
              'classEndTime': updatedValues['classEndTime'],
              'dates': dates.isNotEmpty
                  ? dates
                  : displayClassesModel?.classInfoModel?.days,
            }).then((value) {
              emit(UpdateClassTimePeriodDatesSuccessState());
            }).catchError((error) {
              emit(UpdateClassTimePeriodDatesErrorState());
            });
          });
        });
      }
      return;
    }
  }*/

  Stream<Iterable<AttendedByClassModel>> getAttendanceInClass(String classId) async* {
    //emit(GetClassAttendanceLoadingState());
    yield* FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('attendedBy')
        .snapshots().map((event){
       return event.docs.map((e) {
         print(AttendedByClassModel.fromJson(e.data()).studentRegisterModel?.uId);
         return AttendedByClassModel.fromJson(e.data());});
    });
   /* FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('attendedBy')
        .snapshots()
        .listen((event) {
      classAttendance = [];
      event.docs.forEach((element) {
        classAttendance.add(AttendedByClassModel.fromJson(element.data()));
      });
      //emit(GetClassAttendanceSuccessState());
    });*/
  }

  /* Future<void> deleteClassRoom(String roomUid) async {
    FirebaseFirestore.instance
        .collection('classRooms')
        .doc(roomUid)
        .delete()
        .then((value) {
      //updateClassClassRoomUid();
    }).catchError((error) {
      emit(DeleteClassRoomInfoErrorState(error: error));
    });
  }*/

  /*Future<void> deleteCourse(String courseId) async {
    FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .delete()
        .then((value) {
      updateClassCourseUid();
    }).catchError((error) {
      emit(DeleteCourseErrorState(error: error));
    });
  }*/

  /*Future<void> updateClassCourseUid() async {
    FirebaseFirestore.instance
        .collection('classes')
        .doc(displayClassesModel?.classInfoModel?.uId)
        .update({'courseId': courseInfoModel?.id}).then((value) {
      classAttendance.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(element.studentRegisterModel?.uId)
            .collection('attend')
            .doc(displayClassesModel?.classInfoModel?.uId)
            .update({'courseId': courseInfoModel?.id});
      });
      emit(DeleteCourseSuccessState());
      emit(UpdateCourseSuccessState());
    });
  }*/

  /*Future<void> updateClassClassRoomUid() async {
    FirebaseFirestore.instance
        .collection('classes')
        .doc(displayClassesModel?.classInfoModel?.uId)
        .update({'classRoomUid': roomInfoModel?.uId}).then((value) {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(displayClassesModel?.classInfoModel?.uId)
          .collection('attendedBy')
          .get()
          .then((value) {
        classAttendance = [];
        value.docs.forEach((element) {
          classAttendance.add(AttendedByClassModel.fromJson(element.data()));
          FirebaseFirestore.instance
              .collection('students')
              .doc(element.data()['uId'])
              .collection('attend')
              .doc(displayClassesModel?.classInfoModel?.uId)
              .update({'classRoomUid': roomInfoModel?.uId}).then((value) {
            emit(DeleteClassRoomInfoSuccessState());
            emit(UpdateClassRoomInfoSuccessState());
          }).catchError((error) {
            emit(UpdateClassRoomInfoErrorState(error: error));
          });
        });
      });
    });
  }*/

  /*Future<void> updateClassRoom(
      String classRoomId, String buildingName, String classId, context) async {
    FirebaseFirestore.instance.collection('classes').doc(classId).update(
        {'classRoomUid': '${buildingName}-${classRoomId}'}).then((value) {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .collection('attendedBy')
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('students')
                .doc(element.data()['uId'])
                .collection('attend')
                .doc(classId)
                .update({'classRoomUid': '${buildingName}-${classRoomId}'});
          });
          showToast(text: 'Class Room Updated', state: ToastStates.SUCCESS);
        } else {
          showToast(text: 'Class Room Updated', state: ToastStates.SUCCESS);
        }
      });
    }).catchError((error) {
      showToast(
          text: 'Error While Updating Class Room', state: ToastStates.ERROR);
    });
  }
*/
  /* Future<void> updateCourse(String courseId, String classId, context) async {
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .update({'courseId': courseId}).then((value) {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .collection('attendedBy')
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('students')
                .doc(element.data()['uId'])
                .collection('attend')
                .doc(classId)
                .update({'courseId': courseId});
          });
          showToast(text: 'Course Updated', state: ToastStates.SUCCESS);
        } else {
          showToast(text: 'Course Updated', state: ToastStates.SUCCESS);
        }
      });
    }).catchError((error) {
      showToast(text: 'Error While Updating Course', state: ToastStates.ERROR);
    });
  }
*/
  /*Future<void> updateClassNumber(
      String classNumber, String classId, context) async {
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .update({'classNumber': classNumber}).then((value) {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .collection('attendedBy')
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('students')
                .doc(element.data()['uId'])
                .collection('attend')
                .doc(classId)
                .update({'classNumber': classNumber});
          });
          showToast(text: 'Class Number Updated', state: ToastStates.SUCCESS);
        } else {
          showToast(text: 'Class Number Updated', state: ToastStates.SUCCESS);
        }
      });
    }).catchError((error) {
      showToast(
          text: 'Error While Updating Class Number', state: ToastStates.ERROR);
    });
  }*/

  Future<void> updatePartially(dynamic updatedValue, String fieldName,
      String classId, String updateType, context) async {
    List dates = [];
    if (updateType == 'dates') {
      updatedValue.forEach((element) {
        if (element[1]) {
          dates.add(element[0]);
        }
      });
      updatedValue = dates;
    }
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .update({fieldName: updatedValue}).then((value) {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .collection('attendedBy')
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('students')
                .doc(element.data()['uId'])
                .collection('attend')
                .doc(classId)
                .update({fieldName: updatedValue});
          });
          if (updateType == 'classNumber') {
            showToast(
                text: 'Class Number Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'classRoom') {
            showToast(
                text: 'Class Room Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'courseId') {
            showToast(
                text: 'Course Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'classStartTime') {
            showToast(
                text: 'Class Start Time Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'classEndTime') {
            showToast(
                text: 'Class End Time Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else {
            List<List<dynamic>> dates = [];
            checkDays.forEach((element) {
              dates.add([element[0], false]);
            });
            checkDays = dates;
            emit(UpdateClassTimePeriodDatesSuccessState());
            showToast(
                text: 'Class Days Updated',
                state: ToastStates.SUCCESS,
                context: context);
          }
        } else {
          if (updateType == 'classNumber') {
            showToast(
                text: 'Class Number Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'classRoom') {
            showToast(
                text: 'Class Room Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'courseId') {
            showToast(
                text: 'Course Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'classStartTime') {
            showToast(
                text: 'Class Start Time Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else if (updateType == 'classEndTime') {
            showToast(
                text: 'Class End Time Updated',
                state: ToastStates.SUCCESS,
                context: context);
          } else {
            List<List<dynamic>> dates = [];
            checkDays.forEach((element) {
              dates.add([element[0], false]);
            });
            checkDays = dates;
            emit(UpdateClassTimePeriodDatesSuccessState());
            showToast(
                text: 'Class Days Updated',
                state: ToastStates.SUCCESS,
                context: context);
          }
        }
      });
    }).catchError((error) {
      if (updateType == 'classNumber') {
        showToast(
            text: 'Error While Updating Class Number',
            state: ToastStates.ERROR,
            context: context);
      } else if (updateType == 'classRoom') {
        showToast(
            text: 'Error While Updating Class Room',
            state: ToastStates.ERROR,
            context: context);
      } else if (updateType == 'courseId') {
        showToast(
            text: 'Error While Updating Course Updated',
            state: ToastStates.ERROR,
            context: context);
      } else if (updateType == 'classStartTime') {
        showToast(
            text: 'Error While Updating Class Start Time',
            state: ToastStates.ERROR,
            context: context);
      } else if (updateType == 'classEndTime') {
        showToast(
            text: 'Error While Updating Class End Time',
            state: ToastStates.ERROR,
            context: context);
      } else {
        emit(UpdateClassTimePeriodDatesErrorState());
        showToast(
            text: 'Error While Updating Class Days',
            state: ToastStates.ERROR,
            context: context);
      }
    });
  }

  Future<void> updateClassInfo(
      Map<String, dynamic> updatedValues, context) async {
    classAttendance = [];
    bool updateCourseName = false;
    /*List<String> roomInfo = displayClassesModel?.classInfoModel?.classRoomUid
        ?.split('-') as List<String>;*/
    if (updatedValues.isNotEmpty) {
      if (updatedValues.containsKey('classNumber')) {
        updatePartially(updatedValues['classNumber'], 'classNumber',
            classInfoModel?.uId as String, 'classNumber', context);
      }
      if (updatedValues.containsKey('courseId')) {
        updatePartially(updatedValues['courseId'].split('-')[1], 'courseId',
            classInfoModel?.uId as String, 'courseId', context);
      }
      if (updatedValues.containsKey('classRoomId')) {
        updatePartially(updatedValues['classRoomId'], 'classRoomUid',
            classInfoModel?.uId as String, 'classRoom', context);
      }
      if (updatedValues.containsKey('classStartTime')) {
        updatePartially(updatedValues['classStartTime'], 'classStartTime',
            classInfoModel?.uId as String, 'classStartTime', context);
      }
      if (updatedValues.containsKey('classEndTime')) {
        updatePartially(updatedValues['classEndTime'], 'classEndTime',
            classInfoModel?.uId as String, 'classEndTime', context);
      }
      if (updatedValues.containsKey('dates')) {
        updatePartially(updatedValues['dates'], 'dates',
            classInfoModel?.uId as String, 'dates', context);
      }
    }
  }

  Future<void> getImagePath(dynamic context) async {
    try {
      var storagePath = await getExternalStorageDirectory();
      imagePath = await File(
          '${storagePath?.path}/${DateTime.now()}_${TimeOfDay.now().format(context)}.png');
      emit(GetImagePathSuccessState());
    } catch (error) {
      emit(GetImagePathErrorState());
    }
  }

  Future<void> captureAndSaveQRCode(context) async {
    screenshotController.capture().then((image) {
      if (image!.isNotEmpty) {
        getImagePath(context).then((value) async {
          await imagePath.writeAsBytes(image);
          print(imagePath);
          saveImage(imagePath.path);
        });
      }
    });
  }

  Future<void> saveImage(String path) async {
    GallerySaver.saveImage(path, albumName: "myApp").then((value) {
      if (value == true) {
        emit(SaveImageSuccessState());
      }
    }).catchError((error) {
      emit(SaveImageErrorState());
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAvailableClasses() {
    return FirebaseFirestore.instance.collection('courses').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAvailableClassRooms() {
    return FirebaseFirestore.instance.collection('classRooms').snapshots();
  }
}
