abstract class InstructorLayoutStates {}


class LogoutErrorState extends InstructorLayoutStates {}

class LogoutSuccessState extends InstructorLayoutStates {}

class InitialInstructorLayoutState extends InstructorLayoutStates {}

class BottomNavBarChangeState extends InstructorLayoutStates {}

class CheckedDayChangeState extends InstructorLayoutStates {}

class SetClassRoomInfoSuccessState extends InstructorLayoutStates {}

class SetClassRoomInfoLoadingState extends InstructorLayoutStates {}

class SetClassRoomInfoErrorState extends InstructorLayoutStates {
  String error;

  SetClassRoomInfoErrorState({required this.error});
}

class SetCourseInfoSuccessState extends InstructorLayoutStates {}

class SetCourseInfoErrorState extends InstructorLayoutStates {
  String error;

  SetCourseInfoErrorState({required this.error});
}

class AddStudentsInClassLoadingState extends InstructorLayoutStates {}

class AddStudentsInClassSuccessState extends InstructorLayoutStates {}

class AddStudentsInClassErrorState extends InstructorLayoutStates {
  String error;

  AddStudentsInClassErrorState({required this.error});
}

class SearchStudentsLoadingState extends InstructorLayoutStates {}

class SearchStudentsSuccessState extends InstructorLayoutStates {}

class SearchStudentsErrorState extends InstructorLayoutStates {
  String error;

  SearchStudentsErrorState({required this.error});
}

class GetCurrentLocationSuccessState extends InstructorLayoutStates {}

class GetCurrentLocationErrorState extends InstructorLayoutStates {}

class GetLiveLocationSuccessState extends InstructorLayoutStates {}

class UpdateCurrentLocationSuccessState extends InstructorLayoutStates {}

class SetClassInfoSuccessState extends InstructorLayoutStates {}

class SetClassInfoErrorState extends InstructorLayoutStates {}

class SetClassLocationSuccessState extends InstructorLayoutStates {}

class SetClassLocationErrorState extends InstructorLayoutStates {}

class UpdateClassLocationSuccessState extends InstructorLayoutStates {}

class UpdateClassLocationErrorState extends InstructorLayoutStates {}

class UpdateClassTimePeriodDatesSuccessState extends InstructorLayoutStates {}

class UpdateClassTimePeriodDatesErrorState extends InstructorLayoutStates {}

class GetImagePathSuccessState extends InstructorLayoutStates {}

class GetImagePathErrorState extends InstructorLayoutStates {}

class SaveImageSuccessState extends InstructorLayoutStates {}

class SaveImageErrorState extends InstructorLayoutStates {}
