
abstract class StudentLoginStates {}

class StudentLoginInitialState extends StudentLoginStates{}

class StudentLoginLoadingState extends StudentLoginStates{}

class StudentLoginSuccessState extends StudentLoginStates{

}

class StudentLoginErrorState extends StudentLoginStates{
  final String error;
  StudentLoginErrorState({required this.error});
}

class StudentChangePasswordVisibilityState extends StudentLoginStates{}