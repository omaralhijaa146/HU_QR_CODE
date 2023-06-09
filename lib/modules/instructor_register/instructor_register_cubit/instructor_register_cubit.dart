import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/instructor_register_model/instructor_register_model.dart';

import 'instructor_register_states.dart';

class InstructorRegisterCubit extends Cubit<InstructorRegisterStates>{
  InstructorRegisterCubit():super(InstructorRegisterInitialState());
  static InstructorRegisterCubit get(context)=>BlocProvider.of(context);
  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;

  void changePasswordVisibility(){
    isPassword=!isPassword;
    suffix= isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(InstructorRegisterChangePasswordVisibilityState());
  }

  void userRegister({
  required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String password,
  }){
    emit(InstructorRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      createUser(
          uId: value.user!.uid,
          email:email,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
      );
    }).catchError((error){
      emit(InstructorRegisterErrorState(error: error.toString()));
    });
  }

  void createUser({
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String uId,
}){
    InstructorRegisterModel model=InstructorRegisterModel(
     uId: uId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
    );

    FirebaseFirestore.instance.collection('instructors').doc(uId).set(model.toMap()).then((value){
      emit(InstructorCreateUserSuccessState());
    }).catchError((error){
      emit(InstructorCreateUserErrorState(error: error.toString()));
    });
  }
}