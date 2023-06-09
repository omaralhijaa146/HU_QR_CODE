class StudentRegisterModel {
  String? uId;
  String? id ;
  String? email;
  String? firstName ;
  String? middleName;
  String? lastName ;
  String? deviceId ;
  String? deviceName ;

  StudentRegisterModel({this.uId,
    this.id,
    this.email,
    this.firstName,
    this.middleName,
    this.lastName,
    this.deviceName,
    this.deviceId,});

  StudentRegisterModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    ;
  }

  Map<String, dynamic> toMap() =>
      {
        'uId': uId,
        'id': id,
        'email': email,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'deviceName': deviceName,
        'deviceId': deviceId,

      };
}
