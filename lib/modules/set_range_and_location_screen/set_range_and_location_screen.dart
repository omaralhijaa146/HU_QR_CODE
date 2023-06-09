import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/shared/components/components.dart';

import '../../layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';

class SetRangeAndLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var classRangeController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return Builder(
      builder: (context) {
        if (InstructorLayoutCubit.get(context).lat == 0 &&
            InstructorLayoutCubit.get(context).long == 0) {
          InstructorLayoutCubit.get(context).getLiveLocation();
        }
        if (InstructorLayoutCubit.get(context).added) {
          myMap(context);
        }
        return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text('Set Class Loacation And Range'),
                  SizedBox(
                    height: 10,
                  ),
                  defaultTextButton(
                      func: () {
                        InstructorLayoutCubit.get(context)
                            .closeLiveLocation()
                            .then((value) {
                          InstructorLayoutCubit.get(context)
                              .setClassLocation(0);
                          InstructorLayoutCubit.get(context)
                              .boardController
                              .nextPage(
                                  duration: Duration(milliseconds: 750),
                                  curve: Curves.fastLinearToSlowEaseIn);
                        }).catchError((error) {});
                      },
                      text: 'Skip',
                      context: context),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      controller: classRangeController,
                      type: TextInputType.number,
                      label: "location range",
                      prefix: Icons.class_outlined,
                      valid: (value) {
                        if (value.isEmpty) {
                          return "null value";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  InstructorLayoutCubit.get(context).long == 0 &&
                          InstructorLayoutCubit.get(context).lat == 0
                      ? Center(child: LinearProgressIndicator())
                      : Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: true,
                                  markers: {
                                    Marker(
                                      markerId: MarkerId("1"),
                                      icon: BitmapDescriptor.defaultMarker,
                                      flat: true,
                                      draggable: true,
                                      onDragStart: (value) {
                                        InstructorLayoutCubit.get(context)
                                            .closeLiveLocation();
                                      },
                                      onDragEnd: (value) {
                                        InstructorLayoutCubit.get(context)
                                            .updateLatLng(value);
                                      },
                                      position: LatLng(
                                        InstructorLayoutCubit.get(context).lat
                                            as double,
                                        InstructorLayoutCubit.get(context).long
                                            as double,
                                      ),
                                    ),
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      InstructorLayoutCubit.get(context).lat
                                          as double,
                                      InstructorLayoutCubit.get(context).long
                                          as double,
                                    ),
                                    zoom: 14,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController _controller) async {
                                    InstructorLayoutCubit.get(context)
                                        .controller = _controller;
                                    InstructorLayoutCubit.get(context).added =
                                        true;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text(
                            "Accurate to ${InstructorLayoutCubit.get(context).locationAccuracy.round()}",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: Colors.black, fontSize: 14)),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  InstructorLayoutCubit.get(context)
                                      .closeLiveLocation()
                                      .then((value) =>
                                          InstructorLayoutCubit.get(context)
                                              .setClassLocation(int.parse(
                                                  classRangeController.text)))
                                      .catchError((error) {});
                                }
                                print(
                                    "lat = ${InstructorLayoutCubit.get(context).lat}");
                                print(
                                    "long = ${InstructorLayoutCubit.get(context).long}");
                              },
                              color: Colors.amber,
                              child: Text(
                                "set location range and class location",
                              ),
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is SetClassLocationSuccessState) {
              showToast(
                  text: "Done", state: ToastStates.SUCCESS, context: context);
              InstructorLayoutCubit.get(context).boardController.nextPage(
                    duration: Duration(
                      milliseconds: 750,
                    ),
                    curve: Curves.fastLinearToSlowEaseIn,
                  );
            }
          },
        );
      },
    );
  }
}

void myMap(context) async {
  await InstructorLayoutCubit.get(context).controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                InstructorLayoutCubit.get(context).position?.latitude as double,
                InstructorLayoutCubit.get(context).position?.longitude
                    as double),
            zoom: 17,
          ),
        ),
      );
}
