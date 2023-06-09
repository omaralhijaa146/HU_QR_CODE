
abstract class StudentRegisterStates {}

class StudentRegisterInitialState extends StudentRegisterStates{}

class StudentRegisterLoadingState extends StudentRegisterStates{}

class StudentRegisterSuccessState extends StudentRegisterStates{
  StudentRegisterSuccessState();
}

class StudentRegisterErrorState extends StudentRegisterStates{
  final String error;
  StudentRegisterErrorState({required this.error});
}

class StudentRegisterChangePasswordVisibilityState extends StudentRegisterStates{}

class StudentCreateUserSuccessState extends StudentRegisterStates{}

class StudentCreateUserErrorState extends StudentRegisterStates{
  final String error;
  StudentCreateUserErrorState({required this.error});
}