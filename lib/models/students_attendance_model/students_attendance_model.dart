import 'package:graduation_project/models/attended_by_class_model/attended_by_class_model.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';

class StudentsAttendanceModel {
  AttendedByClassModel? attendedByClassModel;
  bool attended = false;

  StudentsAttendanceModel(
      {required this.attendedByClassModel, this.attended = false});

  StudentsAttendanceModel.fromJson(Map<String, dynamic> json) {
    attendedByClassModel = AttendedByClassModel(
      studentRegisterModel: StudentRegisterModel(
        uId: json['uId'],
        deviceId: json['deviceId'],
        deviceName: json['deviceName'],
        email: json['email'],
        firstName: json['firstName'],
        id: json['id'],
        lastName: json['lastName'],
        middleName: json['middleName'],
      ),
      absenceDays: json['absenceDays'],
    );
    attended = json['attended'];
  }

  Map<String, dynamic> toMap() => {
        'uId': attendedByClassModel?.studentRegisterModel?.uId,
        'deviceId': attendedByClassModel?.studentRegisterModel?.deviceId,
        'deviceName': attendedByClassModel?.studentRegisterModel?.deviceName,
        'email': attendedByClassModel?.studentRegisterModel?.email,
        'firstName': attendedByClassModel?.studentRegisterModel?.firstName,
        'id': attendedByClassModel?.studentRegisterModel?.id,
        'lastName': attendedByClassModel?.studentRegisterModel?.lastName,
        'middleName': attendedByClassModel?.studentRegisterModel?.middleName,
        'absenceDays': attendedByClassModel?.absenceDays,
        'attended': attended
      };
}
