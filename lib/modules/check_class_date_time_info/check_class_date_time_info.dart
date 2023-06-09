import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import '../../layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import '../../shared/components/components.dart';

class CheckClassDateTimeInfo extends StatelessWidget {
  var classStartTimeController = TextEditingController();
  var classEndTimeController = TextEditingController();
  Map<String, dynamic> updatedValues = new Map();

  @override
  Widget build(BuildContext context) {
    classEndTimeController.text =
        InstructorLayoutCubit.get(context).classInfoModel?.classEndTime ??
            "No" as String;
    classStartTimeController.text =
        InstructorLayoutCubit.get(context).classInfoModel?.classStartTime ??
            "NO" as String;

    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text("Edit Class Days And Time Info"),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      classStartTimeController.text =
                          value?.format(context) as String;
                      updatedValues['classStartTime'] =
                          value?.format(context) as String;
                    });
                  },
                  child: defaultFormField(
                    controller: classStartTimeController,
                    type: TextInputType.text,
                    label: "Class Start Time",
                    prefix: Icons.class_outlined,
                    valid: (value) {
                      if (value.isNotEmpty) {
                        if (value != classStartTimeController.text) {
                          updatedValues['classStartTime'] = value.toString();
                        }
                        return null;
                      }
                      return "null value!";
                    },
                    isClickable: false,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            confirmText: 'enter')
                        .then((value) {
                      classEndTimeController.text =
                          value?.format(context) as String;
                      updatedValues['classEndTime'] =
                          value?.format(context) as String;
                    });
                  },
                  child: defaultFormField(
                    controller: classEndTimeController,
                    type: TextInputType.text,
                    label: "Class End Time",
                    prefix: Icons.class_outlined,
                    valid: (value) {
                      if (value.isNotEmpty) {
                        if (value != classEndTimeController.text) {
                          updatedValues['classEndTime'] = value;
                          return null;
                        }
                      }
                      return "null value!";
                    },
                    isClickable: false,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("class days"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        height: 30,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Text(
                                InstructorLayoutCubit.get(context)
                                    .classInfoModel
                                    ?.days![index],
                                style: TextStyle(fontSize: 14),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 5,
                                ),
                            itemCount: InstructorLayoutCubit.get(context)
                                .classInfoModel
                                ?.days
                                ?.length as int),
                      ),
                    ]),
                  ],
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
                      if (updatedValues.isNotEmpty) {
                        InstructorLayoutCubit.get(context)
                            .updateClassInfo(updatedValues, context)
                            .then((value) {
                          updatedValues = {};
                        });
                      } else {
                        showToast(
                          text: "no updates",
                          state: ToastStates.WARNING,
                          context: context,
                        );
                      }
                    },
                    text: "Update"),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget buildDayItem(context, String day, index) => Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Colors.grey[200]),
        child: CheckboxListTile(
          value: InstructorLayoutCubit.get(context).checkDays[index][1],
          onChanged: (value) {
            updatedValues['dates'] =
                InstructorLayoutCubit.get(context).checkDays;
            InstructorLayoutCubit.get(context).selectedDaysItems(index);
          },
          title: Text(day),
        ),
      );
}
