import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/modules/instructor_login/insrtuctor_login_screen.dart';
import 'package:graduation_project/shared/components/components.dart';

import 'instructor_register_cubit/instructor_register_cubit.dart';
import 'instructor_register_cubit/instructor_register_states.dart';

class InstructorRegisterScreen extends StatelessWidget {
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
      create: (context) => InstructorRegisterCubit(),
      lazy: false,
      child: BlocConsumer<InstructorRegisterCubit, InstructorRegisterStates>(
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
                                return "check your name ";
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
                                return "check your name ";
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
                                return "check your name ";
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
                                      r'^.+([\D]{3,})+[@]+[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+$')
                                  .hasMatch(value)) {
                                if (value.split("@")[1] != "staff.hu.edu.jo") {
                                  return "check your email domain";
                                }
                              } else if (!RegExp(
                                      r'^.+([\D]{3,})+[@]+[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+$')
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
                                InstructorRegisterCubit.get(context).isPassword,
                            label: "Password",
                            prefix: Icons.lock_outlined,
                            suffix: InstructorRegisterCubit.get(context).suffix,
                            suffixPressed: () {
                              InstructorRegisterCubit.get(context)
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
                        state is! InstructorRegisterLoadingState
                            ? defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    InstructorRegisterCubit.get(context)
                                        .userRegister(
                                      firstName: fNameController.text,
                                      middleName: sNameController.text,
                                      lastName: lNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
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
          if (state is InstructorCreateUserSuccessState) {
            navigateAndReplace(context: context, widget: InstructorLogin());
          }
        },
      ),
    );
  }
}
