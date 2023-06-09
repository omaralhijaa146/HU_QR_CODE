import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';

class ClassAttendancePageView extends StatelessWidget {
  const ClassAttendancePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        return PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: InstructorLayoutCubit.get(context).board3Controller,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                InstructorLayoutCubit.get(context).boardingList3[index],
                if (index > 0)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20, right: 20),
                      child: CircleAvatar(
                        radius: 30,
                        child: IconButton(
                            onPressed: () {
                              InstructorLayoutCubit.get(context)
                                  .board3Controller
                                  .previousPage(
                                      duration: Duration(milliseconds: 750),
                                      curve: Curves.fastLinearToSlowEaseIn);
                            },
                            icon: Icon(Icons.arrow_upward)),
                      ),
                    ),
                  ),
                if (index > 0)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20, left: 20),
                      child: CircleAvatar(
                        radius: 30,
                        child: IconButton(
                            tooltip: 'Add New List',
                            onPressed: () {
                              InstructorLayoutCubit.get(context)
                                  .setNewAttendanceList();
                            },
                            icon: Column(
                              children: [
                                Icon(Icons.add),
                              ],
                            )),
                      ),
                    ),
                  ),
              ],
            );
          },
          itemCount: InstructorLayoutCubit.get(context).boardingList3.length,
        );
      },
      listener: (context, state) {},
    );
  }
}
