import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/modules/navigators/login_navigator.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/network/local/cache_helper.dart';

import 'instructor_login_states.dart';

class InstructorLoginCubit extends Cubit<InstructorLoginStates> {
  InstructorLoginCubit() : super(InstructorLoginInitialState());
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  static InstructorLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required email,
    required password,
    context
  }) {
    emit(InstructorLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value1) {
          FirebaseFirestore.instance.collection('instructors').doc(value1.user?.uid).get().then((value){
            CacheHelper.saveData(key: 'uId', value: value1.user?.uid);
            CacheHelper.saveData(key: 'userRole', value: 'instructor');
            emit(InstructorLoginSuccessState(uId: value1.user?.uid as String));
          });
    }).catchError((error) {
      showToast(text: 'Unregistered User', state: ToastStates.WARNING,context: context);
      navigateAndReplace(context: context, widget: LoginNavigator());
      print(Future.error(error.toString()).toString());
      emit(InstructorLoginErrorState(error: error.toString()));
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(InstructorChangePasswordVisibilityState());
  }
}
