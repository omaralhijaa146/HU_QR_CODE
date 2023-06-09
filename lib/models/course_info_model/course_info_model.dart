class CourseInfoModel {
  String? id;
  String? courseName;

  CourseInfoModel({required this.id, required this.courseName});

  CourseInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseName = json['courseName'];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'courseName': courseName,
      };
}
