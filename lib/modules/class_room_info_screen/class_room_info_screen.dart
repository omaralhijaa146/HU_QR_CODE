import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/class_room_info_model/class_room_info_model.dart';
import 'package:graduation_project/shared/components/components.dart';

class ClassRoomInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        return StreamBuilder(
            stream: InstructorLayoutCubit.get(context).getAvailableClassRooms(),
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
                        Text('Set Class Class Room'),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Available Class Rooms : "),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return buildClassRoomItem(
                                  ClassRoomInfoModel.fromJson(snapshot
                                      .data!.docs
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
        if (state is SetClassRoomInfoSuccessState) {
          showToast(text: "Done", state: ToastStates.SUCCESS, context: context);
          InstructorLayoutCubit.get(context).boardController.nextPage(
                duration: Duration(
                  milliseconds: 750,
                ),
                curve: Curves.fastLinearToSlowEaseIn,
              );
        } else if (state is SetClassRoomInfoErrorState) {
          showToast(text: "ERROR", state: ToastStates.ERROR, context: context);
        }
      },
    );
  }

  Widget buildClassRoomItem(ClassRoomInfoModel model, context) {
    return InkWell(
      onTap: () {
        InstructorLayoutCubit.get(context).setClassRoom(
            classRoomId: model.id as String,
            buildingName: model.buildingName as String);
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
}
