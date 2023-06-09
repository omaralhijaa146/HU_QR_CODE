import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/shared/components/components.dart';

class ClassNumberDateInfoScreen extends StatelessWidget {
  var context2;
  List<String> days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday"];

  @override
  Widget build(BuildContext context) {
    var classNumberController = TextEditingController();
    var classStartTimeController = TextEditingController();
    var classEndTimeController = TextEditingController();
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        context2 = InstructorLayoutCubit.get(context).boardingContext;
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text("Set Class Number and Date Info"),
                SizedBox(
                  height: 20,
                ),
                defaultFormField(
                    controller: classNumberController,
                    type: TextInputType.text,
                    label: "Class Number",
                    prefix: Icons.class_outlined,
                    valid: (value) {
                      if (value.isEmpty) {
                        return "null value!";
                      }
                      return null;
                    }),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    //var formatedDate=formatt.parse("${date.hour}:${date.minute}");
                    showTimePicker(
                      context: context2,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      print("value TIME  ${value?.hour}:${value?.minute}");
                      classStartTimeController.text =
                          value?.format(context) as String;
                      ;
                    });
                  },
                  child: defaultFormField(
                      controller: classStartTimeController,
                      isClickable: false,
                      type: TextInputType.text,
                      label: "Class Start Time",
                      prefix: Icons.class_outlined,
                      valid: (value) {
                        if (value.isEmpty) {
                          return "null value!";
                        }
                        return null;
                      }),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    showTimePicker(
                      context: context2,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      print("value TIME  ${value?.hour}:${value?.minute}");
                      classEndTimeController.text =
                          value?.format(context) as String;
                      ;
                    });
                  },
                  child: defaultFormField(
                      controller: classEndTimeController,
                      type: TextInputType.text,
                      label: "Class End Time",
                      prefix: Icons.class_outlined,
                      isClickable: false,
                      valid: (value) {
                        if (value.isEmpty) {
                          return "null value!";
                        }
                        return null;
                      }),
                ),
                SizedBox(
                  height: 15,
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildDayItem(
                        context,
                        InstructorLayoutCubit.get(context).checkDays[index][0],
                        index),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 5,
                        ),
                    itemCount:
                        InstructorLayoutCubit.get(context).checkDays.length),
                SizedBox(
                  height: 15,
                ),
                defaultButton(
                    function: () {
                      InstructorLayoutCubit.get(context)
                          .setClass(
                              classEndTime: classEndTimeController.text,
                              classStartTime: classStartTimeController.text,
                              classNumber: classNumberController.text)
                          .then((value) {
                        InstructorLayoutCubit.get(context)
                            .boardController
                            .nextPage(
                              duration: Duration(
                                milliseconds: 750,
                              ),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                      });
                    },
                    text: "enter"),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is SetClassInfoSuccessState) {
          InstructorLayoutCubit.get(context)
              .boardController
              .nextPage(
                duration: Duration(
                  milliseconds: 750,
                ),
                curve: Curves.fastLinearToSlowEaseIn,
              )
              .then((value) {
            showToast(
                text: 'Done', state: ToastStates.SUCCESS, context: context);
          });
        }
      },
    );
  }

  Widget buildDayItem(context, String day, index) => Container(
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
