class StudentAttendList{
  String? stdId;
  int? absenceDays=0;
  bool? isAttended;

  StudentAttendList({
    this.stdId,
    this.absenceDays,
    this.isAttended,
});

  StudentAttendList.fromJson(Map<String,dynamic>json){
    stdId=json["stdId"];
    absenceDays=json["absenceDays"];
    isAttended=json['isAttended'];
  }

  Map<String,dynamic>toMap(){
    return {
      "stdId":stdId,
      "absenceDays":absenceDays,
      'isAttended': isAttended,
    };
  }

}