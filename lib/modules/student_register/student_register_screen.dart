import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/modules/student_login/student_login_screen.dart';
import 'package:graduation_project/shared/components/components.dart';

import 'student_login_cubit/student_register_cubit.dart';
import 'student_login_cubit/student_register_states.dart';

class StudentRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var fNameController = TextEditingController();
  var sNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var stdIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentRegisterCubit(),
      lazy: false,
      child: BlocConsumer<StudentRegisterCubit, StudentRegisterStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Icon(Icons.qr_code_rounded),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.qr_code_rounded,
                                size: 120,
                              ),
                              Text(
                                "HU-QR",
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          "REGISTER",
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: fNameController,
                            type: TextInputType.name,
                            label: "First Name",
                            prefix: Icons.person,
                            valid: (value) {
                              if (value.isEmpty) {
                                return "please enter your name";
                              } else if (RegExp(r'^[a-zA-Z]$')
                                  .hasMatch(value)) {
                                return "check your ID ";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: sNameController,
                            type: TextInputType.name,
                            label: "Middle Name",
                            prefix: Icons.person,
                            valid: (value) {
                              if (value.isEmpty) {
                                return "please enter your name";
                              } else if (RegExp(r'^[a-zA-Z]$')
                                  .hasMatch(value)) {
                                return "check your ID ";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: lNameController,
                            type: TextInputType.name,
                            label: "Last Name",
                            prefix: Icons.person,
                            valid: (value) {
                              if (value.isEmpty) {
                                return "please enter your ID";
                              } else if (RegExp(r'^[a-zA-Z]$')
                                  .hasMatch(value)) {
                                return "check your ID ";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: stdIdController,
                            type: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            label: "Student ID",
                            prefix: Icons.person,
                            valid: (value) {
                              if (value.isEmpty) {
                                return "please enter your ID";
                              } else if (RegExp(r'^.+([\d]{5,})+$')
                                      .hasMatch(value) &&
                                  value.length < 5) {
                                return "the ID is too short";
                              } else if (!RegExp(r'^.+([\d]{5,})+$')
                                  .hasMatch(value)) {
                                return "check your ID ";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: "Email Address",
                            prefix: Icons.email,
                            valid: (value) {
                              if (value.isEmpty) {
                                return "please enter your email address";
                              } else if (RegExp(
                                      r'^.+([\d]{5,})+[@]+[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+$')
                                  .hasMatch(value)) {
                                if (value.split("@")[1] != "std.hu.edu.jo") {
                                  return "check your email domain";
                                }
                              } else if (!RegExp(
                                      r'^.+([\d]{5,})+[@]+[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+$')
                                  .hasMatch(value)) {
                                return "not valid email address";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            obsecure:
                                StudentRegisterCubit.get(context).isPassword,
                            label: "Password",
                            prefix: Icons.lock_outlined,
                            suffix: StudentRegisterCubit.get(context).suffix,
                            suffixPressed: () {
                              StudentRegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            valid: (value) {
                              if (value.isEmpty) {
                                return "Password is too short";
                              }
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        state is! StudentRegisterLoadingState
                            ? defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    StudentRegisterCubit.get(context)
                                        .userRegister(
                                      firstname: fNameController.text,
                                      middleName: sNameController.text,
                                      lastName: lNameController.text,
                                      id: stdIdController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context
                                    );
                                  }
                                },
                                text: "register",
                                isUpperCase: true,
                              )
                            : Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is StudentCreateUserSuccessState) {
            navigateAndReplace(context: context, widget: StudentLogin());
          }
        },
      ),
    );
  }
}
