import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'student_register_states.dart';

class StudentRegisterCubit extends Cubit<StudentRegisterStates> {
  StudentRegisterCubit() : super(StudentRegisterInitialState());

  static StudentRegisterCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(StudentRegisterChangePasswordVisibilityState());
  }

  void userRegister({
    required String firstname,
    required String middleName,
    required String lastName,
    required String id,
    required String email,
    required String password,
    context
  }) async {
    emit(StudentRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      print('token ${await value.user?.getIdToken()}');
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo? androidDeviceInfo;
      IosDeviceInfo? iosDeviceInfo;
      String? deviceId;
      if (Platform.isAndroid) {
        androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = await PlatformDeviceId.getDeviceId;
      } else {
        iosDeviceInfo = await deviceInfo.iosInfo;
      }
      print('**********************************************************');
      print(deviceId);
      print(androidDeviceInfo?.product);
      print('**********************************************************');
      createUser(
        id: id,
        uId: value.user!.uid,
        email: email,
        middleName: middleName,
        lastName: lastName,
        firstname: firstname,
        deviceName: androidDeviceInfo?.product as String,
        deviceId: deviceId as String,
      );
    }).catchError((error) {
      showToast(text: 'Student Finished Studying Years', state: ToastStates.WARNING,context: context);
      emit(StudentRegisterErrorState(error: error.toString()));
    });
  }

  void createUser({
    required String firstname,
    required String middleName,
    required String lastName,
    required String id,
    required String email,
    required String uId,
    required String deviceId,
    required String deviceName,
  }) {
    StudentRegisterModel model = StudentRegisterModel(
      lastName: lastName,
      firstName: firstname,
      middleName: middleName,
      email: email,
      uId: uId,
      id: id,
      deviceId: deviceId,
      deviceName: deviceName,
    );

    FirebaseFirestore.instance
        .collection('students')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(StudentCreateUserSuccessState());
    }).catchError((error) {
      emit(StudentCreateUserErrorState(error: error.toString()));
    });
  }
}
