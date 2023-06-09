import 'package:graduation_project/models/class_info_model/class_info_model.dart';

class DisplayClassesModel {
  String? courseName;
  ClassInfoModel? classInfoModel;

  DisplayClassesModel({
    required this.classInfoModel,
    required this.courseName,
  });

/* DisplayClassesModel.fromJson(Map<String, dynamic> json) {
    classInfoModel = ClassInfoModel(
      classNumber: json['classNumber'],
      classTime: json['classTime'],
      instructorUid: json['uId'],
      classPeriod: json['classPeriod'],
      days: json['days'],
      classLocationModel: ClassLocationModel(
        latitude: json['location']['latitude'],
        longitude: json['location']['longitude'],
        range: json['location']['range'],
      ),
      classRoomUid: json['classRoomUid'],
      courseId: json['courseId'],
    );
  }*/
}
