import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/modules/navigators/login_navigator.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/network/local/cache_helper.dart';

import 'social_login_states.dart';

class StudentLoginCubit extends Cubit<StudentLoginStates> {
  StudentLoginCubit() : super(StudentLoginInitialState());
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  static StudentLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required email,
    required password,
    context
  }) {
    emit(StudentLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value1) {
              CacheHelper.saveData(key: 'uId', value: value1.user?.uid).then((value) {
                CacheHelper.saveData(key: 'userRole', value: 'student');
                emit(StudentLoginSuccessState());
              });
    }).catchError((error) {
      showToast(text: 'Unregistered User', state: ToastStates.WARNING,context: context);
      navigateAndReplace(context: context, widget: LoginNavigator());
      print(Future.error(error.toString()).toString());
      emit(StudentLoginErrorState(error: error.toString()));
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(StudentChangePasswordVisibilityState());
  }
/*FirebaseFirestore.instance
      .collection('students')
      .doc(value.user?.uid)
      .get()
      .then((value) async {
  AndroidDeviceInfo? androidDeviceInfo;
  IosDeviceInfo? iosDeviceInfo;
  String deviceId = await PlatformDeviceId.getDeviceId as String;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
  androidDeviceInfo = await deviceInfo.androidInfo;
  } else {
  iosDeviceInfo = await deviceInfo.iosInfo;
  }
  if (value.data()!['deviceName'] != androidDeviceInfo?.product) {
  throw Error();
  } else {
  CacheHelper.saveData(key: 'userRole', value: "student").then((value) {
  emit(StudentLoginSuccessState());
  });
  }
  });*/
}
