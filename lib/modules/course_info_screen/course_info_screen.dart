import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/course_info_model/course_info_model.dart';
import 'package:graduation_project/shared/components/components.dart';

class CourseInfoScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        var cubit = InstructorLayoutCubit.get(context);
        return StreamBuilder(
            stream: InstructorLayoutCubit.get(context).getAvailableClasses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('Set Class Course'),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Available Courses : "),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return buildCourseItem(
                                  CourseInfoModel.fromJson(snapshot.data!.docs
                                      .elementAt(index)
                                      .data()),
                                  context);
                            },
                            separatorBuilder: (context, index) => myDividor(),
                            itemCount: snapshot.data!.docs.length),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error'));
              } else {
                return Text('no classes');
              }
            });
      },
      listener: (context, state) {
        if (state is SetCourseInfoSuccessState) {
          showToast(text: "Done", state: ToastStates.SUCCESS, context: context);
          InstructorLayoutCubit.get(context).boardController.nextPage(
                duration: Duration(
                  milliseconds: 750,
                ),
                curve: Curves.fastLinearToSlowEaseIn,
              );
        } else if (state is SetCourseInfoErrorState) {
          showToast(text: "ERROR", state: ToastStates.ERROR, context: context);
        }
      },
    );
  }

  Widget buildCourseItem(CourseInfoModel model, context) {
    return InkWell(
      onTap: () {
        InstructorLayoutCubit.get(context).setCourse(
            courseId: model.id as String,
            courseName: model.courseName as String);
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
