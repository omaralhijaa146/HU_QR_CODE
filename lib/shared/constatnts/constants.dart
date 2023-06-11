
import 'package:geolocator/geolocator.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/network/local/cache_helper.dart';

var uId;
var token;
var userRole;
LocationPermission? permission;
LocationSettings? locationSettings;
void printFullText(String text){
  final pattern=RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}
