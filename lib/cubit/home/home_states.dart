abstract class HomeStates {}

class HomeInitialStates extends HomeStates {}

class ChangeBottomNav extends HomeStates {}

class HomeLoadingData extends HomeStates {}

class HomeSuccessData extends HomeStates {}

class HomeErrorData extends HomeStates {
  final String error;

  HomeErrorData(this.error);
}
