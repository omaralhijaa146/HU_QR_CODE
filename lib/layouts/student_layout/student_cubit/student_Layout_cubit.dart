import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_states.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/models/display_classes_model/display_classes_model.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/modules/SettingsScreen/SettingsScreen.dart';
import 'package:graduation_project/modules/get_classes_students_screen/get_classes_student_screen.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/constatnts/constants.dart';
import 'package:graduation_project/shared/network/local/cache_helper.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../../modules/navigators/login_navigator.dart';

class StudentLayoutCubit extends Cubit<StudentLayoutStates> {
  StudentLayoutCubit() : super(InitialStudentLayoutState());

  static StudentLayoutCubit get(context) => BlocProvider.of(context);
  String? courseName = '';
  List<Widget> layoutScreens = [
    GetClassesStudentScreen(),
    SettingsScreen(),
  ];
  List<BottomNavigationBarItem> bottomNavBar = [
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Scan),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Profile),
      label: "Profile",
    ),
  ];
  dynamic contextLayout;
  int currentIndex = 0;
  double lat = 0;
  double long = 0;
  double locationAccuracy = 0;
  Position? position;
  StreamSubscription? subscription;
  StudentRegisterModel? studentRegisterModel;
  ClassInfoModel? classInfoModel;
  List<ClassInfoModel> classesList = [];
  List<DisplayClassesModel> displayClassesList = [];
  int classesListSize = 0;
  bool getClassesFirstTime = true;
  bool onChanges = false;
  List<String> wrongInfo = [];

  //MobileScannerController mobileScannerController=MobileScannerController();
  Future<bool> getInfo() async {
    uId = CacheHelper.getData(key: "uId");
    print("U&UUUUUUUUUUUUIIIIIIIIIIIIIIIIIDDDDDDDDDD $uId");
    if (studentRegisterModel != null) return true;
    return FirebaseFirestore.instance
        .collection("students")
        .doc(uId)
        .get()
        .then((value) {
      studentRegisterModel =
          StudentRegisterModel.fromJson(value.data() as Map<String, dynamic>);
      print("student UISSSSDDDDDD ${studentRegisterModel?.uId}");
      return true;
    }).catchError((error) {
      return false;
    });
  }
  Future<void> updateStudentInfo(
      Map<String, dynamic> updatedValues, context) async {
    FirebaseFirestore.instance
        .collection('students')
        .doc(studentRegisterModel?.uId)
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

  Future<Position> getCurrentLocation() {
    print("permission is NOT NULLLLLLLL $permission");
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    );
  }

  /*Stream<Map<String, String>> getCurrentLocation1() async* {
    print("permission is NOT NULLLLLLLL $permission");

    yield* await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    ).then((value) {
      return {'deg': 'dg'};
    });
  }*/
  Map<String, bool> checkingProcess = {};
  List<Map<String, String>> checkingp = [];
  bool streamEnd = false;

  Stream<List<Map<String, String>>> checkIfAttended1(
      String classUid, ClassInfoModel classInfoModel) async* {
    double? distance = 0.0;
    checkingp = [];
    await Future.delayed(Duration(seconds: 2, milliseconds: 500));
    yield* checkClassInfo(classUid, classInfoModel);
    //await Future.delayed(Duration(seconds: 4));
    if (checkingProcess['check class info'] == true) {
      yield* await getDeviceInfo().then((deviceInfo) async* {
        print('DEVICE NAMEEEEEE ${deviceInfo['deviceName']}');
        if (deviceInfo['deviceId'] == studentRegisterModel?.deviceId &&
            deviceInfo['deviceName'] == studentRegisterModel?.deviceName) {
          checkingProcess['check device info'] = true;
          checkingp.add({
            'check device info': 'checked',
          });
          yield checkingp;
          print('DEVICE NAMEEEEEE ${deviceInfo['deviceName']}');
        } else {
          checkingp.add({
            'check device info': 'wrong',
          });
          checkingProcess['check device info'] = false;
          yield checkingp;

          wrongInfo.add("unregistered device");
          throw Error();
        }
      }).catchError((error) {
        print('ERRORRRRRRRRRRRRRRRRRRRRRRRRRRRR');
      });
      //await Future.delayed(Duration(seconds: 4));
      if (checkingProcess['check device info'] == true) {
        print('GETTING LOCATION************************************');
        yield* await getCurrentLocation().then((value) async* {
          print('SETTTT LOCATION************************************');
          distance = Geolocator.distanceBetween(
              classInfoModel.classLocationModel?.latitude as double,
              classInfoModel.classLocationModel?.longitude as double,
              value.latitude,
              value.longitude);
          int distanceInt = distance!.toInt();
          int range = classInfoModel.classLocationModel?.range as int;
          print("DISTANCE####333333333###  ${distance}");
          if (distanceInt <= range||range==0) {
            checkingProcess['check student location'] = true;
            print('DISTANCE************************************');
            checkingp.add({
              'check student location': 'checked',
            });
            yield checkingp;
            print("DISTANCE####44444444###  ${distanceInt}");
          } else {
            checkingProcess['check student location'] = false;
            checkingp.add({
              'check student location': 'wrong',
            });
            yield checkingp;
            wrongInfo.add("not of class range");
          }
        }).catchError((error) async* {
          throw error.toString();
        });
        if (checkingProcess['check student location'] == true&&classInfoModel.classLocationModel?.range==0) {
          String dateNow = DateFormat('yMEd')
              .format(DateTime.now())
              .replaceAll('/', '-')
              .replaceAll(',', '-')
              .replaceAll(' ', '');
          print('CLASSDATEEEE ${dateNow}');
          String docRef = '';
          print('INST UID  ${classInfoModel.instructorUid}');
          print('Class UID  ${classInfoModel.uId}');
          print('IS FIRSTTTTTTTTT');
          await FirebaseFirestore.instance
              .collection('attendanceLists')
              .doc(classInfoModel.instructorUid)
              .collection(classInfoModel.uId as String)
              .where('classDate', isEqualTo: dateNow)
              .get()
              .then((value) async {
            print('DOCS>LENGTHHHHHH  ${value.docs.length}');
            if (value.docs.length > 0) {
              docRef = value.docs[0].reference.id;
              print('docRefffffffffffffffffffff ${docRef}');
              await FirebaseFirestore.instance
                  .collection('attendanceLists')
                  .doc(classInfoModel.instructorUid)
                  .collection(classInfoModel.uId as String)
                  .doc(docRef)
                  .collection('students')
                  .doc(studentRegisterModel?.uId)
                  .update({'attended': true}).then((value) {
                checkingp.add({
                  'sign attendance list': 'signed',
                });
              }).catchError((error) {
                checkingp.add({
                  'sign attendance list': 'unsigned',
                });
              });
            } else {
              checkingp.add({
                'sign attendance list': 'unsigned',
              });
            }
          }).catchError((error) {
            checkingp.add({
              'sign attendance list': 'unsigned',
            });
          });
          print('IS SECONDDDDDDDDD');
          yield checkingp;
        } else {
          checkingp.add({
            'sign attendance list': 'unsigned',
          });
          yield checkingp;
        }
      } else {
        checkingp.add({
          'check student location': 'wrong',
        });
        yield checkingp;
      }
    }
    streamEnd = true;
  }

/* print('VALUE  PATHTHTHTHTH   ${value}');
          yield* await FirebaseFirestore.instance
              .doc(value.id)
              .collection('students')
              .doc(studentRegisterModel?.uId)
              .set(studentRegisterModel?.toMap() as Map<String, dynamic>)
              .then((value) async* {
            yield* await FirebaseFirestore.instance
                .collection('classes')
                .doc(classInfoModel.uId)
                .collection('attendedBy')
                .doc(studentRegisterModel?.uId)
                .update({'markedDownPhone': true, 'markedDownPc': true}).then(
                    (value) async* {
                  checkingp.add({
                    'sign attendance list': 'signed',
                  });
                  yield checkingp;
                  //emit(CheckIfAttendedSuccessState());
                  print('updateddddddddddddd');
                }).catchError((error) async* {
              checkingp.add({
                'sign attendance list': 'unsigned',
              });
              yield checkingp;
              print('updateddddddddddddd ERRROROROOROROR');
              wrongInfo.add("check your internet connection");
              throw Error();
            });
            print('doc Settttttttttttttttttt');
          }).catchError((error) {
            print('doc Settttttttttttttttttt Errorororoororororo');
            wrongInfo.add("check your internet connection");
            throw Error();
          });
        } as FutureOr<Stream<List<Map<String, String>>>> Function(QuerySnapshot<Map<String, dynamic>> value));
        } else {
          yield checkingp;
        }
        //await Future.delayed(Duration(seconds: 4));
      } else {
        yield checkingp;
      }
    } else {
      yield checkingp;
      await Future.delayed(Duration(seconds: 2));*/
  Future<void> getLiveLocation() async {
    /*if (lat == 0 && long == 0) {
      getCurrentLocation().then((value) async {
        subscription =
            Geolocator.getPositionStream(locationSettings: locationSettings)
                .listen((event) {
          lat = event.latitude;
          long = event.longitude;
          locationAccuracy = event.accuracy;
        });
        emit(GetLiveLocationSuccessState());
      });
      return;
    }*/
    subscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((event) {
      lat = event.latitude;
      long = event.longitude;
      locationAccuracy = event.accuracy;

      emit(GetLiveLocationSuccessState());
    });
  }

  Future<void> closeLiveLocation() async {
    subscription?.cancel().then((value) {
      emit(CloseStreamLocationSuccessState());
    });
  }

  bool checkClassDay(List<dynamic> days) {
    String dayNow = DateFormat("EEEE").format(DateTime.now());
    print('DAY NOW  ${dayNow}');
    for (String day in days) {
      if (day == dayNow.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  void scanComplete() {
    emit(ScannComplete());
  }

  Stream<List<Map<String, String>>> checkClassInfo(
    String classUid,
    ClassInfoModel classInfoModel,
  ) async* {
    if (classUid == classInfoModel.uId) {
      if (checkClassDay(classInfoModel.days as List<dynamic>) &&
          checkClassTime(classInfoModel.classStartTime as String,
              classInfoModel.classEndTime as String)) {
        checkingProcess['check class info'] = true;
        checkingp.add({
          'check class info': 'checked',
        });
        yield checkingp;
      } else {
        wrongInfo.add("wrong time or day");
        checkingProcess['check class info'] = false;
        checkingp.add({
          'check class info': 'wrong',
        });
        yield checkingp;
      }
    } else {
      checkingProcess['check class info'] = false;
      checkingp.add({
        'check class info': 'wrong',
      });
      wrongInfo.add("wrong QR Code");
      yield checkingp;
    }
  }

  /*void checkIfAttended(String classUid, ClassInfoModel classInfoModel) {
    double? distance = 0.0;
    //emit(CheckIfAttendedLoadingState());
    getCurrentLocation().then((value) {
      distance = Geolocator.distanceBetween(
          classInfoModel.classLocationModel?.latitude as double,
          classInfoModel.classLocationModel?.longitude as double,
          value.latitude,
          value.longitude);
      print("DISTANCE####333333333###  ${distance}");
      int distanceInt = distance!.toInt();
      int range = classInfoModel.classLocationModel?.range as int;
      if (distanceInt <= range) {
        print("DISTANCE####44444444###  ${distanceInt}");
        getDeviceInfo().then((deviceInfo) {
          print('DEVICE NAMEEEEEE ${deviceInfo['deviceName']}');
          if (deviceInfo['deviceId'] == studentRegisterModel?.deviceId &&
              deviceInfo['deviceName'] == studentRegisterModel?.deviceName) {
            print('DEVICE NAMEEEEEE ${deviceInfo['deviceName']}');
            if (checkClassInfo(classUid, classInfoModel)) {
              FirebaseFirestore.instance
                  .collection('attendanceList')
                  .doc(classInfoModel.instructorUid)
                  .collection(classInfoModel.uId as String)
                  .doc(studentRegisterModel?.uId)
                  .set(studentRegisterModel?.toMap() as Map<String, dynamic>)
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('classes')
                    .doc(classInfoModel.uId)
                    .collection('attendedBy')
                    .doc(studentRegisterModel?.uId)
                    .update({'markedDown': true}).then((value) {
                  emit(CheckIfAttendedSuccessState());
                  print('updateddddddddddddd');
                }).catchError((error) {
                  print('updateddddddddddddd ERRROROROOROROR');
                  wrongInfo.add("check your internet connection");
                  throw Error();
                });
                print('doc Settttttttttttttttttt');
              }).catchError((error) {
                print('doc Settttttttttttttttttt Errorororoororororo');
                wrongInfo.add("check your internet connection");
                throw Error();
              });
            } else {
              //emit(CheckIfAttendedErrorState());
            }
          } else {
            wrongInfo.add("unregistered device");
            throw Error();
          }
        }).catchError((error) {
          print('ERRORRRRRRRRRRRRRRRRRRRRRRRRRRRR');
        });
      } else {
        wrongInfo.add("not of class range");
        throw Error();
      }
    }).catchError((error) {
      //emit(CheckIfAttendedErrorState());
    });
  }*/

  bool studentLiveLocation = true;

  bool checkStudentLocation(int range, double latitude, double longitude) {
    double? distance = 0.0;

    getCurrentLocation(); /*.then((value) {
      print('lat = ${lat}   long = ${long}');

      */ /* while (studentLiveLocation) {
        distance = Geolocator.distanceBetween(
            latitude, longitude, lat as double, long as double);
        print("DISTANCE   ${(distance)?.round()} M");
        print('lat = ${lat as double}   long = ${long as double}');
        if ((distance)?.round() as int <= range) {
          closeLiveLocation().then((value) {
            print("DISTANCE   ${distance}");
            print("LOCATION SUCSEEESSSDSSDS ");
            studentLiveLocation = false;
          });
          return true;
        }
      }*/ /*
      return false;
    });*/
    print("GEOLOACTION LATITUDE ${GeoPoint(latitude, longitude).longitude}");

    /*print("DISTANCE   ${int.parse('$distance')}");
    int.parse('$distance') <= range
        ? closeLiveLocation().then((value) {
            print("LOCATION SUCSEEESSSDSSDS ");
          })
        : getLiveLocation().then((value) {
            print("LOCATION FAILLLLL");
          });*/
    return studentLiveLocation ? false : true;
  }

  Future<Map<String, String>> getDeviceInfo() async {
    AndroidDeviceInfo? androidDeviceInfo;
    IosDeviceInfo? iosDeviceInfo;
    String? deviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = await PlatformDeviceId.getDeviceId as String;

      return {
        'deviceName': androidDeviceInfo.product,
        'deviceId': deviceId,
      };
    }
    iosDeviceInfo = await deviceInfo.iosInfo;
    deviceId = await PlatformDeviceId.getDeviceId as String;
    return {
      'deviceName': iosDeviceInfo.name as String,
      'deviceId': deviceId,
    };
  }

  /*void getClassStudentInfo(String classUid) async {
    emit(GetClassInfoLoadingState());
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classUid)
        .collection('attendedBy')
        .doc(studentRegisterModel?.uId)
        .get().then((value) {
      classInfoModel =
          ClassInfoModel.fromJson(value.data() as Map<String, dynamic>);
      emit(GetClassSuccessState());
    }).catchError((error) {
      emit(GetClassInfoErrorState());
    });
  }*/

  String minutesToHours(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${(hour).toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  bool checkClassTime(String openTime, String closedTime) {
    //NOTE: Time should be as given format only
    //10:00PM
    //10:00AM

    // 01:60PM ->13:60
    //Hrs:Min
    //if AM then its ok but if PM then? 12+time (12+10=22)
    TimeOfDay timeNow = TimeOfDay.now();
    String openHr = openTime.substring(0, openTime.indexOf(':'));
    print("openHR $openHr");
    String openMin =
        openTime.substring(openTime.indexOf(':') + 1, openTime.indexOf(' '));
    print("openMin $openMin");
    String openAmPm = openTime.substring(openTime.indexOf(' ') + 1);
    print("openAMPM $openAmPm");
    TimeOfDay timeOpen;
    if (openAmPm == "AM") {
      //am case
      if (openHr == "12") {
        //if 12AM then time is 00
        timeOpen = TimeOfDay(hour: 00, minute: int.parse(openMin));
      } else {
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      }
    } else {
      //pm case
      if (openHr == "12") {
//if 12PM means as it is
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      } else {
//add +12 to conv time to 24hr format
        timeOpen =
            TimeOfDay(hour: int.parse(openHr) + 12, minute: int.parse(openMin));
      }
    }

    String closeHr = closedTime.substring(0, closedTime.indexOf(':'));
    print("closeHR $closeHr");
    String closeMin = closedTime.substring(
        openTime.indexOf(':') + 1, closedTime.indexOf(' '));
    print("closeMin $closeMin");
    String closeAmPm = closedTime.substring(closedTime.indexOf(' ') + 1);
    print("closeAMPM $closeAmPm");
    TimeOfDay timeClose;

    if (closeAmPm == "AM") {
      //am case
      if (closeHr == "12") {
        timeClose = TimeOfDay(hour: 0, minute: int.parse(closeMin));
      } else {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      }
    } else {
      //pm case
      if (closeHr == "12") {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      } else {
        timeClose = TimeOfDay(
            hour: int.parse(closeHr) + 12, minute: int.parse(closeMin));
      }
    }

    int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
    int openTimeInMinutes = timeOpen.hour * 60 + timeOpen.minute;
    int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;

//handling day change ie pm to am
    if ((closeTimeInMinutes - openTimeInMinutes) < 0) {
      closeTimeInMinutes = closeTimeInMinutes + 1440;
      if (nowInMinutes >= 0 && nowInMinutes < openTimeInMinutes) {
        nowInMinutes = nowInMinutes + 1440;
      }
      if (openTimeInMinutes < nowInMinutes &&
          nowInMinutes < closeTimeInMinutes) {
        return true;
      }
    } else if (openTimeInMinutes < nowInMinutes &&
        nowInMinutes < closeTimeInMinutes) {
      return true;
    }

    return false;
  }

  Map<String, dynamic> getCourseClassRoomInfo(
      String courseId, String classRoomUid) {
    Map<String, dynamic> map = {};
    FirebaseFirestore.instance
        .collection('courses')
        .where('id', isEqualTo: courseId)
        .get()
        .then((course) async {
      FirebaseFirestore.instance
          .collection('classRooms')
          .where('uId', isEqualTo: classRoomUid)
          .get()
          .then((classRoom) {
        map['courseName'] = course.docs[0].data()['courseName'];
        print('courseName ${map['courseName']}');
        map['buildingName'] = classRoom.docs[0].data()['buildingName'];
        print('buildingName ${map['buildingName']}');
        map['classRoomId'] = classRoom.docs[0].data()['id'];
        print('classRoomId ${map['classRoomId']}');
      });
    });
    return map;
  }

  Stream<Iterable<ClassInfoModel>> getClassesInfo() async* {
    yield* FirebaseFirestore.instance
        .collection("students")
        .doc(studentRegisterModel?.uId)
        .collection("attend")
        .orderBy('courseId')
        .orderBy('classNumber')
        .snapshots()
        .asyncMap((event) async {
      return await event.docs.map((e) {
        return ClassInfoModel.fromJson(e.data());
      });
    });
  }

  Stream<String> getCourseName(String courseId) async* {
    print("courseIDDDDDDDDDDDDDDDDDDDDDD  ${courseId}");
    yield* FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .asyncMap((event) => event.data()?['courseName']);
  }

  void changeBottomNavBarState(int index) {
    currentIndex = index;
    emit(BottomNavBarChangeState());
  }
}
