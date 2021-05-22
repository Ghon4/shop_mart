import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/home/home_states.dart';
import 'package:shop_mart/model/home_model.dart';
import 'package:shop_mart/network/end_points.dart';
import 'package:shop_mart/network/remote/dio_helper.dart';
import 'package:shop_mart/screens/categories_screen.dart';
import 'package:shop_mart/screens/favorites_screen.dart';
import 'package:shop_mart/screens/products_screen.dart';
import 'package:shop_mart/screens/settings_screen.dart';

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

  void getHomeData() {
    emit(HomeLoadingData());
    DioHelper.getData(url: HOME).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print(homeModel.data.banners[0].image);
      emit(HomeSuccessData());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorData(error.toString()));
    });
  }
}
