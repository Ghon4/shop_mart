import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/login/login_states.dart';
import 'package:shop_mart/model/login_model.dart';
import 'package:shop_mart/network/end_points.dart';
import 'package:shop_mart/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel loginModel;
  void userLogin({
    @required String email,
    @required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);

      print(loginModel.data.token);

      print(value.data);
      emit(LoginSuccessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error));
    });
  }

  bool isPassword = true;
  IconData icon = Icons.visibility_off_outlined;
  void changePasswordVisibility() {
    icon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    isPassword = !isPassword;
    emit(ChangePasswordVisibilitySuccessState());
  }
}
