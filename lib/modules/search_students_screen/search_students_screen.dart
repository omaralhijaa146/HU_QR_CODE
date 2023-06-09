import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_layout.dart';
import 'package:graduation_project/models/attended_by_class_model/attended_by_class_model.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/shared/components/components.dart';

class SearchStudentsScreen extends StatelessWidget {
  const SearchStudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Add Students To The Class",
                  ),
                  Spacer(),
                  defaultTextButton(
                      func: () {
                        navigateAndReplace(
                            context: context, widget: InstructorLayout());
                      },
                      text: "SKIP",
                      context: context)
                ],
              ),
              defaultFormField(
                  controller: searchController,
                  type: TextInputType.text,
                  label: "search",
                  prefix: Icons.search,
                  onChange: (value) {
                    InstructorLayoutCubit.get(context).searchForStudents(value);
                  },
                  valid: (value) {}),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (context) {
                  return Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => searchItemBuilder(
                          context,
                          InstructorLayoutCubit.get(context)
                              .searchResult[index],
                          index),
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: Colors.black54,
                      ),
                      itemCount: InstructorLayoutCubit.get(context)
                          .searchResult
                          .length,
                    ),
                  );
                },
              ),
              defaultButton(
                  function: () {
                    navigateAndReplace(
                        context: context, widget: InstructorLayout());
                  },
                  text: "Finish")
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget searchItemBuilder(context, AttendedByClassModel student, index) {
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
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: defaultButton(
                      radius: 20,
                      function: () {
                        InstructorLayoutCubit.get(context).addStudentsInClass(
                            student,
                            InstructorLayoutCubit.get(context).classInfoModel
                                as ClassInfoModel);
                      },
                      text: "Add"),
                )
              ],
            ),
          )
        : Container();
  }
}
