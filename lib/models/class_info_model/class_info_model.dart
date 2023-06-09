import 'package:graduation_project/models/class_location_model/class_location_model.dart';

class ClassInfoModel {
  String? classNumber;
  String? courseId;
  String? instructorUid;
  String? classEndTime;
  String? classStartTime;
  String? classRoomUid;
  ClassLocationModel? classLocationModel;
  List? days = [];
  String? uId;
  int? color;

  ClassInfoModel(
      {required this.classNumber,
      required this.classStartTime,
      required this.instructorUid,
      required this.classEndTime,
      required this.days,
      required this.classLocationModel,
      required this.classRoomUid,
      required this.courseId,
      this.uId,
      this.color});

  ClassInfoModel.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    classLocationModel = ClassLocationModel(
        latitude: json['location']['latitude'] ?? 00,
        longitude: json['location']['longitude'] ?? 00,
        range: json['location']['range']);
    classNumber = json['classNumber'];
    instructorUid = json['instructorUid'];
    classRoomUid = json['classRoomUid'];
    classEndTime = json['classEndTime'];
    //dates=json['dates'].entries.map((e)=>DateInfoModel(day: e.key,hour: e.value)).toList() as List<DateInfoModel>;
    /*json['dates'].forEach((key, value) {
      dates?.add(DateInfoModel(day: key, hour: value));
      print("key  $key");
    });*/
    days = json['dates'];
    classStartTime = json['classStartTime'];
    uId = json['uId'];
    color = json['color'];
  }

  Map<String, dynamic> toMap() {
    /* Map<String, dynamic>? datesToMap = Map.fromIterable(dates!,
        key: (key) => key.day, value: (value) => value.hour);*/
    return {
      "location": classLocationModel?.toMap(),
      "classNumber": classNumber,
      "courseId": courseId,
      'classStartTime': classStartTime,
      "classRoomUid": classRoomUid,
      "instructorUid": instructorUid,
      "classEndTime": classEndTime,
      "dates": days,
      "uId": uId,
      'color': color,
    };
  }
}
