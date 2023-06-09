import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/attended_by_class_model/attended_by_class_model.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/shared/components/components.dart';

class EditClassAttendanceScreen extends StatelessWidget {
  ClassInfoModel? classModel;
  dynamic contextLayout;

  EditClassAttendanceScreen({this.classModel, this.contextLayout});

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    classModel =
        InstructorLayoutCubit.get(context).classInfoModel as ClassInfoModel;
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text('Edit Class Attendance'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        label: "search",
                        prefix: Icons.search,
                        valid: (value) {},
                        onChange: (value) {
                          InstructorLayoutCubit.get(context)
                              .searchForStudents(value);
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return attendanceItemBuilder(
                            context,
                            InstructorLayoutCubit.get(context)
                                .searchResult[index],
                            index,
                            true);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 15,
                      ),
                      itemCount: InstructorLayoutCubit.get(context)
                          .searchResult
                          .length),
                  SizedBox(
                    height: 25,
                  ),
                  myDividor(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Students in Class"),
                  ),
                  myDividor(),
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                      stream: InstructorLayoutCubit.get(context).getAttendanceInClass(classModel?.uId as String),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }

                        if(snapshot.hasData){
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return attendanceItemBuilder(
                                    context,
                                    snapshot.data!.elementAt(index),
                                    index,
                                    false);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                              itemCount: snapshot.data!.length);
                        }
                        else if(snapshot.hasError){
                          return Center(child: Text('Error While Getting Attendance'));
                        }else{
                          return Center(child: Text('No Attendance'));
                        }
                      }
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget attendanceItemBuilder(
    context,
    AttendedByClassModel student,
    index,
    bool isSearch,
  ) {
    return student.studentRegisterModel?.id != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(
                      "${student.studentRegisterModel?.firstName![0]} ${student.studentRegisterModel?.lastName![0]}"),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    Text(
                        "${student.studentRegisterModel?.firstName} ${student.studentRegisterModel?.lastName}"),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${student.studentRegisterModel?.id}",
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
                Spacer(),
                defaultButton(
                    width: 80,
                    radius: 20,
                    function: () {
                      isSearch
                          ? InstructorLayoutCubit.get(context)
                              .addStudentsInClass(student, classModel!)
                          : InstructorLayoutCubit.get(context)
                              .removeStudentFromClass(
                                  classModel?.uId as String,
                                  student.studentRegisterModel
                                      as StudentRegisterModel);
                    },
                    text: isSearch ? "Add" : "Remove")
              ],
            ),
          )
        : Container();
  }
}
