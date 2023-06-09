import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CheckClassInfoScreen extends StatelessWidget {
  ClassInfoModel classInfoModel;
  String courseName;
  dynamic layoutContext;

  CheckClassInfoScreen(
      {required this.classInfoModel,
      required this.courseName,
      required this.layoutContext});

  @override
  Widget build(BuildContext context) {
    int boardIndex = 0;
    // String courseId=courseIdController.text=model?.courseId  ??"";
    // String roomId=roomIdController.text=model?.classRoomInfoModel!.id ??"";
    // String buildingName=buildingNameController.text=model?.classRoomInfoModel?.buildingName ??"";
    // List<String> classDates=[];
    // String? classTime=classTimeController.text=model?.dates?.first.hour ?? "";
    // model?.dates?.forEach((element) {
    //   classDates.add(element.day ??"");
    // });
    // List<bool> isUpdated = [];
    return BlocProvider<InstructorLayoutCubit>(
      create: (context) => InstructorLayoutCubit()
        ..classInfoModel = classInfoModel
        ..contextLayout = layoutContext
        ..courseName = courseName,
      lazy: false,
      child: BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
        builder: (context, state) {
          InstructorLayoutCubit.get(context).boardingContext = context;
          return Scaffold(
            appBar: AppBar(
              title: Icon(
                Icons.qr_code_rounded,
                size: 30,
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      print('index  ${index}');
                      boardIndex = index;
                      return InstructorLayoutCubit.get(context)
                          .boardingList2[index];
                    },
                    itemCount:
                        InstructorLayoutCubit.get(context).boardingList2.length,
                    onPageChanged: (index) {},
                    controller:
                        InstructorLayoutCubit.get(context).board2Controller,
                    physics: BouncingScrollPhysics(),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 10, start: 10, top: 10),
                    child: Row(
                      children: [
                        SmoothPageIndicator(
                          controller: InstructorLayoutCubit.get(context)
                              .board2Controller,
                          count: InstructorLayoutCubit.get(context)
                              .boardingList2
                              .length,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            dotHeight: 10,
                            dotWidth: 10,
                            expansionFactor: 4,
                            spacing: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

Widget buildDayItem(context, String day, index) {
  return Container(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25), color: Colors.grey[200]),
    child: CheckboxListTile(
      value: InstructorLayoutCubit.get(context).checkDays[index][1],
      onChanged: (value) {
        InstructorLayoutCubit.get(context).selectedDaysItems(index);
      },
      title: Text(day),
    ),
  );
}

// if (courseIdController.text !=
// InstructorLayoutCubit.get(context)
// .courseInfoModel
//     ?.id ||
// courseNameController.text !=
// InstructorLayoutCubit.get(context)
// .courseInfoModel
//     ?.courseName) {
// InstructorLayoutCubit.get(context)
//     .updateCourse(
// courseId: courseId,
// courseName: courseName,
// updatedCourseId: courseIdController.text,
// updatedCourseName: courseNameController.text)
//     .then((value) {
//
// checkUserPermission(context).then((value) =>  isUpdated.add(true));
// });
//
// }
// if (roomIdController.text !=
// InstructorLayoutCubit.get(context)
// .roomInfoModel
//     ?.id ||
// buildingNameController.text !=
// InstructorLayoutCubit.get(context)
// .roomInfoModel
//     ?.buildingName) {
// InstructorLayoutCubit.get(context)
//     .updateClassRoom(
// classRoomId: roomId,
// buildingName: buildingName,
// updatedClassRoomId: roomIdController.text,
// updatedBuildingName: buildingNameController.text,
// )
//     .then((value) => isUpdated.add(true));
// }
//
// if (isUpdated.length == 1 || isUpdated.length == 2) {
// InstructorLayoutCubit.get(context)
//     .boardController
//     .nextPage(
// duration: Duration(
// milliseconds: 750,
// ),
// curve: Curves.fastLinearToSlowEaseIn,
// );
// } else {
// InstructorLayoutCubit.get(context)
//     .boardController
//     .nextPage(
// duration: Duration(
// milliseconds: 750,
// ),
// curve: Curves.fastLinearToSlowEaseIn,
// );
// }
