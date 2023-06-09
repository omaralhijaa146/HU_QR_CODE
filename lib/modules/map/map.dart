import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';

class GoogleMapp extends StatelessWidget {
  ClassInfoModel classInfoModel;

  GoogleMapp({required this.classInfoModel});

  var classRangeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstructorLayoutCubit>(
      create: (context) =>
          InstructorLayoutCubit()..classInfoModel = this.classInfoModel,
      lazy: false,
      child: Builder(builder: (context) {
        classRangeController.text =
            "${InstructorLayoutCubit.get(context).classInfoModel?.classLocationModel?.range}";
        if (InstructorLayoutCubit.get(context).lat == 0 &&
            InstructorLayoutCubit.get(context).long == 0) {
          InstructorLayoutCubit.get(context).getLiveLocation();
        }
        if (InstructorLayoutCubit.get(context).added) {
          myMap(context);
        }
        return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Scaffold(
                body: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              InstructorLayoutCubit.get(context)
                                  .closeLiveLocation()
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            },
                            icon: Icon(
                              IconBroken.Close_Square,
                              size: 25,
                            ),
                          ),
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
                          height: 10,
                        ),
                        InstructorLayoutCubit.get(context).lat != 0 &&
                                InstructorLayoutCubit.get(context).long != 0
                            ? Expanded(
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
                              )
                            : Center(child: LinearProgressIndicator()),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Text(
                                  "Accurate to ${InstructorLayoutCubit.get(context).locationAccuracy.round()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          color: Colors.black, fontSize: 14)),
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
                                            .whenComplete(() {
                                          InstructorLayoutCubit.get(context)
                                              .setClassLocation(int.parse(
                                                  classRangeController.text))
                                              .then((value) {
                                            InstructorLayoutCubit.get(context)
                                                .updateClassLocation()
                                                .then((value) {});
                                          });
                                        });
                                      }
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
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {},
        );
      }),
    );
  }

  void myMap(context) async {
    await InstructorLayoutCubit.get(context).controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(InstructorLayoutCubit.get(context).lat as double,
                  InstructorLayoutCubit.get(context).long as double),
              zoom: 17,
            ),
          ),
        );
  }
}
