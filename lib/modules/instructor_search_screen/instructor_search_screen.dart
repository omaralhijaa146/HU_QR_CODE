import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/shared/components/components.dart';

class InstructorSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? previousSearchValue;
    var searchController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              defaultFormField(
                controller: searchController,
                type: TextInputType.text,
                label: "search",
                prefix: Icons.search,
                valid: (value) {
                  if (value.isEmpty) {
                    return " null value";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              if (InstructorLayoutCubit.get(context).searchResultModel != null)
                buildSearchItem(InstructorLayoutCubit.get(context)
                    .searchResultModel as StudentRegisterModel),
              defaultButton(
                function: () {
                  if (formKey.currentState!.validate()) {
                    InstructorLayoutCubit.get(context)
                        .searchForStudents(searchController.text);
                  }
                  searchController.text = "";
                },
                text: "search",
              ),
              SizedBox(
                height: 15,
              ),
              defaultButton(
                function: () {
                  if (formKey.currentState!.validate()) {
                    InstructorLayoutCubit.get(context)
                        .searchStudents(searchController.text);
                  }
                },
                text: "search",
              )
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget buildSearchItem(StudentRegisterModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text(
                "${model.firstName![0] + ' ' + model.lastName![0]}",
                style: TextStyle(
                  color: Colors.grey[100],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.firstName}  ${model.lastName}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${model.id}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
