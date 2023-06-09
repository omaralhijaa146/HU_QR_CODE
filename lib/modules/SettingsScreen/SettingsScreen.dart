import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_cubit.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_states.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var firstNameController = TextEditingController();
    var middleNameController = TextEditingController();
    var lastNameController = TextEditingController();
    var emailController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    Map<String, dynamic> updatedValues = new Map();
    return BlocConsumer<StudentLayoutCubit, StudentLayoutStates>(
      builder: (context, state) {
        return FutureBuilder(
            future: StudentLayoutCubit.get(context).getInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              }
              if (snapshot.hasData) {
                firstNameController.text = StudentLayoutCubit.get(context)
                    .studentRegisterModel
                    ?.firstName as String;
                middleNameController.text = StudentLayoutCubit.get(context)
                    .studentRegisterModel
                    ?.middleName as String;
                lastNameController.text = StudentLayoutCubit.get(context)
                    .studentRegisterModel
                    ?.lastName as String;
                emailController.text = StudentLayoutCubit.get(context)
                    .studentRegisterModel
                    ?.email as String;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 190.0,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                CircleAvatar(
                                  radius: 65.0,
                                  child: Text(
                                      '${StudentLayoutCubit.get(context).studentRegisterModel?.firstName![0]}${StudentLayoutCubit.get(context).studentRegisterModel?.lastName![0]}',
                                      style: TextStyle(fontSize: 50)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                              prefix: IconBroken.User,
                              radius: 0,
                              controller: firstNameController,
                              //nameController,
                              valid: (value) {
                                if (value.isEmpty) {
                                  return "field is empty";
                                }
                                updatedValues['firstName'] = value;
                                firstNameController.text = value;
                                return null;
                              },
                              type: TextInputType.name,
                              label: "First Name"),
                          SizedBox(
                            height: 10.0,
                          ),
                          defaultFormField(
                              prefix: IconBroken.User,
                              radius: 0,
                              controller: middleNameController,
                              //nameController,
                              valid: (value) {
                                if (value.isEmpty) {
                                  return "field is empty";
                                }
                                updatedValues['middleName'] = value;
                                middleNameController.text = value;
                                return null;
                              },
                              type: TextInputType.name,
                              label: "Middle Name"),
                          SizedBox(
                            height: 10.0,
                          ),
                          defaultFormField(
                              prefix: IconBroken.User,
                              radius: 0,
                              controller: lastNameController,
                              //nameController,
                              valid: (value) {
                                if (value.isEmpty) {
                                  return "field is empty";
                                }
                                updatedValues['lastName'] = value;
                                lastNameController.text = value;
                                return null;
                              },
                              type: TextInputType.name,
                              label: "Last Name"),
                          SizedBox(
                            height: 10.0,
                          ),
                          defaultFormField(
                              prefix: IconBroken.Message,
                              radius: 0,
                              controller: emailController,
                              //bioController,
                              valid: (value) {
                                if (value.isEmpty) {
                                  return "field is empty";
                                }
                                updatedValues['email'] = value;
                                emailController.text = value;
                                return null;
                              },
                              type: TextInputType.text,
                              label: "Email"),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  StudentLayoutCubit.get(context)
                                      .updateStudentInfo(
                                      updatedValues, context);
                                }
                              },
                              text: "Update"),
                          SizedBox(
                            height: 10,
                          ),
                          defaultButton(
                              function: () {
                                StudentLayoutCubit.get(context)
                                    .logout(context);
                              },
                              text: "logout"),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error');
              } else {
                return Text('No Info');
              }
            });
      },
      listener: (context, state) {},
    );
  }
}
