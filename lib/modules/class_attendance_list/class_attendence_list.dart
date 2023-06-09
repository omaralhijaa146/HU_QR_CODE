import 'package:flutter/material.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';

class ClassAttendanceList extends StatelessWidget {
  const ClassAttendanceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Classes Attendance Lists'),
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
            stream: InstructorLayoutCubit.get(context).getClassesInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return SingleChildScrollView(
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => buildClassItem(
                            snapshot.data?.elementAt(index) as ClassInfoModel,
                            InstructorLayoutCubit.get(context).contextLayout,
                            context),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: snapshot.data!.length),
                  );
                } else {
                  return Center(child: Text('no Classes'));
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Error'));
              } else {
                return Center(child: Text('No Classes'));
              }
            }),
      ],
    );
  }

  Widget buildClassItem(ClassInfoModel model, mainContext, contextClassesList) {
    return StreamBuilder(
      stream: InstructorLayoutCubit.get(contextClassesList)
          .getCourseName(model.courseId as String),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              InstructorLayoutCubit.get(context).classInfoModel = model;
              InstructorLayoutCubit.get(context).board3Controller.nextPage(
                  duration: Duration(
                    milliseconds: 750,
                  ),
                  curve: Curves.fastLinearToSlowEaseIn);
            },
            child: Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(model.color as int),
                    ),
                    child: Center(
                      child: Text(
                          '${snapshot.data![0]}${snapshot.data![snapshot.data!.length - 1]}'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('${snapshot.data}'),
                  SizedBox(
                    width: 10,
                  ),
                  Text('${model.classNumber}  Lists'),
                  Spacer(),
                  Icon(IconBroken.Arrow___Right_2),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print('NULLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');
          return Text('error');
        } else {
          print('NULLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');
          return Text('no class');
        }
      },
    );
  }
}
