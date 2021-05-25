import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/home/home_states.dart';
import 'package:shop_mart/model/category_model.dart';
import 'package:shop_mart/model/change_favorites_model.dart';
import 'package:shop_mart/model/favorite_model.dart';
import 'package:shop_mart/model/home_model.dart';
import 'package:shop_mart/model/login_model.dart';
import 'package:shop_mart/network/end_points.dart';
import 'package:shop_mart/network/remote/dio_helper.dart';
import 'package:shop_mart/screens/categories_screen.dart';
import 'package:shop_mart/screens/favorites_screen.dart';
import 'package:shop_mart/screens/products_screen.dart';
import 'package:shop_mart/screens/settings_screen.dart';
import 'package:shop_mart/widgets/constants.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialStates());
  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List screens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNav());
  }

  HomeModel homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(HomeLoadingData());
    DioHelper.getData(url: HOME).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });
      emit(HomeSuccessData());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorData(error.toString()));
    });
  }

  CategoriesModel categoryModel;

  void getCategory() {
    emit(CategoryLoadingData());
    DioHelper.getData(url: GET_CATEGORIES).then((value) {
      categoryModel = CategoriesModel.fromJson(value.data);
      emit(CategorySuccessData());
    }).catchError((error) {
      print(error.toString());
      emit(CategoryErrorData(error.toString()));
    });
  }

  ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];

    emit(ChangeFavSuccessState(changeFavoritesModel));

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel.status) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavorites();
      }

      emit(ChangeFavSuccessState(changeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId];

      emit(ChangeFavErrorState(error.toString()));
    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  LoginModel loginModel;

  void getUserData() {
    emit(UserDataLoadingState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);

      emit(UserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UserDataErrorState());
    });
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel.data.name);

      emit(ShopSuccessUpdateUserState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
