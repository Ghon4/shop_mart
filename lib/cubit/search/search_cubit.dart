import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/search/search_states.dart';
import 'package:shop_mart/model/search_model.dart';
import 'package:shop_mart/network/end_points.dart';
import 'package:shop_mart/network/remote/dio_helper.dart';
import 'package:shop_mart/widgets/constants.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel model;

  void search(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      model = SearchModel.fromJson(value.data);

      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
