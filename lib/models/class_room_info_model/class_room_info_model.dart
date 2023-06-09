class ClassRoomInfoModel {
  String? id;

  String? buildingName;
  String? uId;

  ClassRoomInfoModel({required this.id, required this.buildingName, this.uId});

  ClassRoomInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buildingName = json['buildingName'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'buildingName': buildingName,
        'uId': '${buildingName}-${id}',
      };
}
