
abstract class InstructorRegisterStates {}

class InstructorRegisterInitialState extends InstructorRegisterStates{}

class InstructorRegisterLoadingState extends InstructorRegisterStates{}

class InstructorRegisterSuccessState extends InstructorRegisterStates{
  InstructorRegisterSuccessState();
}

class InstructorRegisterErrorState extends InstructorRegisterStates{
  final String error;
  InstructorRegisterErrorState({required this.error});
}

class InstructorRegisterChangePasswordVisibilityState extends InstructorRegisterStates{}

class InstructorCreateUserSuccessState extends InstructorRegisterStates{}

class InstructorCreateUserErrorState extends InstructorRegisterStates{
  final String error;
  InstructorCreateUserErrorState({required this.error});
}