import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_layout.dart';
import 'package:graduation_project/modules/instructor_login/instructor_login_cubit/instructor_login_cubit.dart';
import 'package:graduation_project/modules/instructor_login/instructor_login_cubit/instructor_login_states.dart';
import 'package:graduation_project/modules/instructor_register/instructor_register_screen.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/network/local/cache_helper.dart';

class InstructorLogin extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => InstructorLoginCubit(),
      lazy: false,
      child: BlocConsumer<InstructorLoginCubit, InstructorLoginStates>(
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
                                InstructorLoginCubit.get(context).isPassword,
                            label: "Password",
                            prefix: Icons.lock_outlined,
                            suffix: InstructorLoginCubit.get(context).suffix,
                            suffixPressed: () {
                              InstructorLoginCubit.get(context)
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
                        state is! InstructorLoginLoadingState
                            ? Container(
                                width: double.infinity,
                                child: defaultButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        InstructorLoginCubit.get(context)
                                            .userLogin(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          context: context
                                        );
                                      }
                                    },
                                    text: 'Login'),
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
                                  .titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            defaultTextButton(
                                context: context,
                                func: () {
                                  navigateTo(
                                      context: context,
                                      widget: InstructorRegisterScreen());
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
          if (state is InstructorLoginSuccessState) {
            CacheHelper.saveData(key: 'userRole', value: "instructor")
                .then((value) {
              CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
                navigateAndReplace(
                    context: context, widget: InstructorLayout());
              }).catchError((error) {
                print(error.toString());
              });
            }).catchError((error) {});
          } else if (state is InstructorLoginErrorState) {
            showToast(text: "${state.error}", state: ToastStates.ERROR);
          }
        },
      ),
    );
  }
}
