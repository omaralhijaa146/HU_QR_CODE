
import 'package:geolocator/geolocator.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/network/local/cache_helper.dart';

var uId;
var token;
var userRole;
String mapsApiKey="AIzaSyByFNCSIuggDSbuLtfYc_QDPTJp1euX5W0";
LocationPermission? permission;
LocationSettings? locationSettings;
void signOut(context){
  CacheHelper.removeData(key: "token").then((value){
    if(value){
      //navigateAndReplace(context, QRCodeScannerLogin());
    }
  });
}
void printFullText(String text){
  final pattern=RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}