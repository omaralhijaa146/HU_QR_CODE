class DateInfoModel{
  String?day;
  String? hour;
  DateInfoModel({
    this.day,
    this.hour,
  });
  DateInfoModel.fromJson(Map<String,dynamic>json){
    day=json['day'];
    hour=json['hour'];
  }

  Map<String,dynamic>toMap()=>{
   'day':day,
    'hour':hour,
  };
}
