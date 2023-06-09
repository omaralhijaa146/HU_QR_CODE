import 'package:flutter/material.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/modules/check_class_info_screen/check_class_info_screen.dart';
import 'package:graduation_project/shared/change_notifier/change_notifier.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/services_and_permissions/services_and_permissions.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';
import 'package:provider/provider.dart';

import '../create_class_screen/create_class_screen.dart';

class GetClassesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkUserPermission(context);
    // InstructorLayoutCubit.get(context).getInstructorInfo();
    return Stack(
      children: [
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return StreamBuilder(
                  stream: InstructorLayoutCubit.get(context).getClassesInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Instructor Classes'),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return buildClassesItem(
                                        snapshot.data!.elementAt(index),
                                        InstructorLayoutCubit.get(context)
                                            .contextLayout,
                                        context);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        width: 20,
                                      ),
                                  itemCount: snapshot.data!.length),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('error classes'));
                    } else {
                      return Center(child: Text('no classes'));
                    }
                  });
            } else if (snapshot.hasError) {
              return Text('Error Ins');
            } else {
              return Text('no data');
            }
          },
          future: InstructorLayoutCubit.get(context).getInstructorInfo(),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, left: 20),
            child: CircleAvatar(
              radius: 30,
              child: IconButton(
                  tooltip: 'Add New List',
                  onPressed: () {
                    navigateTo(context: context, widget: ClassInfoScreen());
                  },
                  icon: Column(
                    children: [
                      Icon(Icons.add),
                    ],
                  )),
            ),
          ),
        )
      ],
    );
  }

  Widget buildClassesItem(
      ClassInfoModel model, contextMain, contextGetClassScreen) {
    List<String> classRoomInfo = model.classRoomUid?.split('-') as List<String>;
    return StreamBuilder(
        stream: InstructorLayoutCubit.get(contextGetClassScreen)
            .getCourseName(model.courseId as String),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Dismissible(
              key: Key('${model.uId}'),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  InstructorLayoutCubit.get(context)
                      .deleteClass(model, contextGetClassScreen);
                }
              },
              background: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(IconBroken.Delete), Text('Delete')],
                    ),
                  ),
                ),
                color: Colors.red,
              ),
              child: InkWell(
                onTap: () {
                  InstructorLayoutCubit.get(contextGetClassScreen)
                      .classInfoModel = model;
                  InstructorLayoutCubit.get(contextGetClassScreen).courseName =
                      snapshot.data;
                  navigateTo(
                      context: contextMain,
                      widget: CheckClassInfoScreen(
                        classInfoModel: model,
                        courseName: snapshot.data as String,
                        layoutContext: contextMain,
                      ));
                },
                child: ChangeNotifierProvider<ChangeNotifierHUQR>(
                  create: (context) => ChangeNotifierHUQR(),
                  child: Consumer<ChangeNotifierHUQR>(
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                Text('${model.classNumber}'),
                                Spacer(),
                                Icon(IconBroken.Arrow___Right_2),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 4, top: 4),
                            child: Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child:
                                    context.read<ChangeNotifierHUQR>().isDone ==
                                            false
                                        ? InkWell(
                                            onTap: () {
                                              context
                                                  .read<ChangeNotifierHUQR>()
                                                  .setPosition(true);
                                            },
                                            child: Icon(
                                                size: 17,
                                                IconBroken.Arrow___Right_2))
                                        : InkWell(
                                            onTap: () {
                                              context
                                                  .read<ChangeNotifierHUQR>()
                                                  .setPosition(false);
                                            },
                                            child: Icon(
                                                size: 17,
                                                IconBroken.Arrow___Down_2))),
                          ),
                          if (context.read<ChangeNotifierHUQR>().isDone)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Course ID ${model.courseId}'),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text('Building ${classRoomInfo[0]}'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Room ID ${classRoomInfo[1]}'),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('ERROR');
          } else {
            return Text('reload');
          }
        });
  }
}
