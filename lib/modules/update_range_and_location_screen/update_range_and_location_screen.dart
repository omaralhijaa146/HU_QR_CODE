import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/modules/map/map.dart';
import 'package:graduation_project/shared/styles/colors.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';

import '../../layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';

class UpdateRangeAndLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context2, state) {
        return Column(
          children: [
            SizedBox(height: 10),
            Text('Edit Class Location And Range'),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Icon(
              IconBroken.Location,
              size: 300,
            )),
            Center(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context2,
                    builder: (context) {
                      return PageView.builder(
                        itemBuilder: (context, index) => GoogleMapp(
                            classInfoModel: InstructorLayoutCubit.get(context2)
                                .classInfoModel as ClassInfoModel),
                        itemCount: 1,
                        physics: NeverScrollableScrollPhysics(),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  radius: 50,
                  child: Text(
                    'Show Map',
                  ),
                ),
              ),
            ),
          ],
        );
      },
      listener: (context, state) {
      },
    );
  }
}
