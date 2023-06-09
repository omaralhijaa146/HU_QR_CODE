

/*

class AttendStudentModel {
  ClassInfoModel? classInfoModel;
  int? absenceDays;

  AttendStudentModel({
    this.classInfoModel,
    this.absenceDays,
  });

  AttendStudentModel.fromJson(Map<String, dynamic> json) {
     classInfoModel=ClassInfoModel(
         classNumber: classNumber,
         classTime: classTime,
         instructorUid: instructorUid,
         classPeriod: classPeriod,
         days: days,
         classLocationModel: classLocationModel,
         classRoomUid: classRoomUid,
         courseId: courseId
     );
    absenceDays=json["absenceDays"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = classInfoModel!.toMap();
    map.addAll({"absenceDays": absenceDays});
    return map;
  }
}
*/
