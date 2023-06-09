import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ClassInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InstructorLayoutCubit()..boardingContext = context,
      child: BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(title: Icon(Icons.qr_code_rounded)),
              body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller:
                            InstructorLayoutCubit.get(context).boardController,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          if (index ==
                              InstructorLayoutCubit.get(context)
                                      .boardingList
                                      .length -
                                  1) {
                            InstructorLayoutCubit.get(context)
                                .isCreateClassLastStep = true;
                          } else {
                            InstructorLayoutCubit.get(context)
                                .isCreateClassLastStep = false;
                          }
                        },
                        itemBuilder: (context, index) =>
                            InstructorLayoutCubit.get(context)
                                .boardingList
                                .elementAt(index),
                        itemCount: InstructorLayoutCubit.get(context)
                            .boardingList
                            .length,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      children: [
                        SmoothPageIndicator(
                          controller: InstructorLayoutCubit.get(context)
                              .boardController,
                          count: InstructorLayoutCubit.get(context)
                              .boardingList
                              .length,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            dotHeight: 10,
                            dotWidth: 10,
                            expansionFactor: 4,
                            spacing: 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        },
        listener: (context, state) {},
      ),
    );
  }
}
