import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/models/class_room_info_model/class_room_info_model.dart';
import 'package:graduation_project/models/course_info_model/course_info_model.dart';
import 'package:graduation_project/shared/components/components.dart';

class CheckClassIdInfo extends StatelessWidget {
  var classNumberController = TextEditingController();
  var courseNameIDController = TextEditingController();
  var buildingRoomIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context1, state) {
        ClassInfoModel model = InstructorLayoutCubit.get(context1)
            .classInfoModel as ClassInfoModel;
        String courseNameId =
            '${InstructorLayoutCubit.get(context1).courseName as String}-${model.courseId}';
        classNumberController.text = model.classNumber as String;
        courseNameIDController.text = courseNameId;
        buildingRoomIdController.text = model.classRoomUid as String;
        Map<String, dynamic> updatedValues = new Map();
        var formKey = GlobalKey<FormState>();
        return Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Edit Class Number/Course/Class Room'),
                  SizedBox(
                    height: 40,
                  ),
                  defaultFormField(
                    controller: classNumberController,
                    type: TextInputType.number,
                    label: "Class Number",
                    prefix: Icons.class_outlined,
                    valid: (value) {
                      if (value.isNotEmpty) {
                        if (value != model.classNumber) {
                          updatedValues['classNumber'] = value;
                        }
                        return null;
                      }
                      return "null values";
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context:
                            InstructorLayoutCubit.get(context1).contextLayout,
                        builder: (context) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  top: 35, bottom: 35, start: 20, end: 20),
                              child: StreamBuilder(
                                  stream: InstructorLayoutCubit.get(context1)
                                      .getAvailableClasses(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasData) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Available ClassRooms : "),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return buildCourseItem(
                                                    CourseInfoModel.fromJson(
                                                        snapshot.data!.docs
                                                            .elementAt(index)
                                                            .data()),
                                                    context);
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      myDividor(),
                                              itemCount:
                                                  snapshot.data!.docs.length),
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('Error'));
                                    } else {
                                      return Text('no classes');
                                    }
                                  }),
                            ),
                          );
                        },
                      );
                    },
                    child: defaultFormField(
                      isClickable: false,
                      controller: courseNameIDController,
                      type: TextInputType.text,
                      label: "Course Name-ID",
                      prefix: Icons.school_outlined,
                      valid: (value) {
                        if (value.isNotEmpty) {
                          if (value != courseNameId) {
                            updatedValues['courseId'] = value;
                            updatedValues['courseName'] = value;
                          }
                          return null;
                        }
                        return "null values";
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context:
                            InstructorLayoutCubit.get(context1).contextLayout,
                        builder: (context) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  top: 35, bottom: 35, start: 20, end: 20),
                              child: StreamBuilder(
                                  stream: InstructorLayoutCubit.get(context1)
                                      .getAvailableClassRooms(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasData) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Available ClassRooms : "),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return buildClassRoomItem(
                                                    ClassRoomInfoModel.fromJson(
                                                        snapshot.data!.docs
                                                            .elementAt(index)
                                                            .data()),
                                                    context);
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      myDividor(),
                                              itemCount:
                                                  snapshot.data!.docs.length),
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('Error'));
                                    } else {
                                      return Text('no classes');
                                    }
                                  }),
                            ),
                          );
                        },
                      );
                    },
                    child: defaultFormField(
                        controller: buildingRoomIdController,
                        type: TextInputType.text,
                        label: "BuildingName-Room ID",
                        isClickable: false,
                        prefix: Icons.meeting_room_outlined,
                        valid: (value) {
                          if (value.isNotEmpty) {
                            if (value != model.classRoomUid) {
                              updatedValues['classRoomId'] = value;
                            }
                            return null;
                          }
                          return "null values";
                        },
                        onChange: (value) {}),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultButton(
                      function: () {
                        if (formKey.currentState!.validate()) {
                          if (updatedValues.length > 0) {
                            InstructorLayoutCubit.get(context)
                                .updateClassInfo(updatedValues, context)
                                .then((value) {
                              updatedValues = {};
                              /*InstructorLayoutCubit.get(context)
                                  .board2Controller
                                  .nextPage(
                                      duration: Duration(milliseconds: 750),
                                      curve: Curves.fastLinearToSlowEaseIn);*/
                            });
                          } else {
                            showToast(
                              text: "no updates",
                              state: ToastStates.WARNING,
                              context: context,
                            );
                          }
                        }
                      },
                      text: "Update")
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget buildClassRoomItem(ClassRoomInfoModel model, context) {
    return InkWell(
      onTap: () {
        buildingRoomIdController.text = model.uId as String;
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  model.buildingName as String,
                  softWrap: true,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  model.id as String,
                  softWrap: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCourseItem(CourseInfoModel model, context) {
    return InkWell(
      onTap: () {
        courseNameIDController.text = '${model.courseName}-${model.id}';
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  model.courseName as String,
                  softWrap: true,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  model.id as String,
                  softWrap: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
