class InstructorRegisterModel{

  String? uId="";
  String? email="";
  String? firstName="";
  String? middleName="";
  String? lastName="";

InstructorRegisterModel({
  this.uId,
  this.email,
  this.firstName,
  this.middleName,
  this.lastName
});

  InstructorRegisterModel.fromJson(Map<String,dynamic>json){
    uId=json['uId'];
    email=json['email'];
    firstName=json['firstName'];
    middleName=json['middleName'];
    lastName=json['lastName'];
  }

  Map<String,dynamic> toMap()=>{
    'uId':uId,
    'email':email,
    'firstName':firstName,
    'middleName':middleName,
    'lastName':lastName,
  };
}