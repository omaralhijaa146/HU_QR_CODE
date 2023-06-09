import 'package:graduation_project/models/student_register_model/student_register_model.dart';

class AttendedByClassModel {
  StudentRegisterModel? studentRegisterModel;
  int? absenceDays = 0;

  AttendedByClassModel({
    this.studentRegisterModel,
    this.absenceDays,
  });

  AttendedByClassModel.fromJson(Map<String, dynamic> json) {
    studentRegisterModel = StudentRegisterModel(
      id: json['id'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      uId: json['uId'],
      email: json['email'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
    );
    absenceDays = json['absenceDays'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': studentRegisterModel?.id,
      'deviceId': studentRegisterModel?.deviceId,
      'deviceName': studentRegisterModel?.deviceName,
      'uId': studentRegisterModel?.uId,
      'email': studentRegisterModel?.email,
      'firstName': studentRegisterModel?.firstName,
      'middleName': studentRegisterModel?.middleName,
      'lastName': studentRegisterModel?.lastName,
      'absenceDays': absenceDays,
    };
  }
}
