import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/student_layout/student_layout.dart';
import 'package:graduation_project/modules/student_login/student_login_cubit/student_login_cubit.dart';
import 'package:graduation_project/modules/student_register/student_register_screen.dart';
import 'package:graduation_project/shared/components/components.dart';

import 'student_login_cubit/social_login_states.dart';

class StudentLogin extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => StudentLoginCubit(),
      lazy: false,
      child: BlocConsumer<StudentLoginCubit, StudentLoginStates>(
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
                                size: 150,
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
                          "LOGIN",
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: "Email Address",
                            prefix: Icons.email_outlined,
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
                            obsecure: StudentLoginCubit.get(context).isPassword,
                            label: "Password",
                            prefix: Icons.lock_outlined,
                            suffix: StudentLoginCubit.get(context).suffix,
                            suffixPressed: () {
                              StudentLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            valid: (value) {
                              if (value.isEmpty) {
                                return "please enter your email address";
                              }
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        state is! StudentLoginLoadingState
                            ? Container(
                                width: double.infinity,
                                child: defaultButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        print("valid");
                                        StudentLoginCubit.get(context)
                                            .userLogin(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          context: context
                                        );
                                      }
                                    },
                                    text: 'login'),
                              )
                            : Center(child: CircularProgressIndicator()),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don\'t have an account ? ",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(color: Colors.black),
                            ),
                            defaultTextButton(
                                context: context,
                                func: () {
                                  navigateTo(
                                      context: context,
                                      widget: StudentRegisterScreen());
                                },
                                text: "Register"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is StudentLoginSuccessState) {
            navigateAndReplace(context: context, widget: StudentLayout());
          } else if (state is StudentLoginErrorState) {
            showToast(text: "${state.error}", state: ToastStates.ERROR);
          }
        },
      ),
    );
  }
}
