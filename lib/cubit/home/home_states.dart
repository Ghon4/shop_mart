import 'package:shop_mart/model/change_favorites_model.dart';
import 'package:shop_mart/model/login_model.dart';

abstract class HomeStates {}

class HomeInitialStates extends HomeStates {}

class ChangeBottomNav extends HomeStates {}

class HomeLoadingData extends HomeStates {}

class HomeSuccessData extends HomeStates {}

class HomeErrorData extends HomeStates {
  final String error;

  HomeErrorData(this.error);
}

class CategoryLoadingData extends HomeStates {}

class CategorySuccessData extends HomeStates {}

class CategoryErrorData extends HomeStates {
  final String error;

  CategoryErrorData(this.error);
}

class ChangeFavLoadingState extends HomeStates {}

class ChangeFavSuccessState extends HomeStates {
  ChangeFavSuccessState(ChangeFavoritesModel changeFavoritesModel);
}

class ChangeFavErrorState extends HomeStates {
  final String error;

  ChangeFavErrorState(this.error);
}

class ShopLoadingGetFavoritesState extends HomeStates {}

class ShopSuccessGetFavoritesState extends HomeStates {}

class ShopErrorGetFavoritesState extends HomeStates {}

class UserDataLoadingState extends HomeStates {}

class UserDataSuccessState extends HomeStates {}

class UserDataErrorState extends HomeStates {}

class ShopLoadingUpdateUserState extends HomeStates {}

class ShopSuccessUpdateUserState extends HomeStates {
  final LoginModel loginModel;

  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserState extends HomeStates {}
