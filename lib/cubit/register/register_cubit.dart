// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shop_mart/cubit/register/register_states.dart';
// import 'package:shop_mart/model/login_model.dart';
//
// import 'package:shop_mart/network/end_points.dart';
// import 'package:shop_mart/network/remote/dio_helper.dart';
//
// class RegisterCubit extends Cubit<RegisterStates> {
//   RegisterCubit() : super(RegisterInitialState());
//   static RegisterCubit get(context) => BlocProvider.of(context);
//
//   LoginModel loginModel;
//   void userRegister({
//     @required String email,
//     @required String password,
//     @required String name,
//     @required String phone,
//   }) {
//     emit(RegisterLoadingState());
//     DioHelper.postData(
//       url: REGISTER,
//       data: {
//         'email': email,
//         'password': password,
//         'name': name,
//         'phone': phone,
//       },
//     ).then((value) {
//       loginModel = LoginModel.fromJson(value.data);
//
//       print(loginModel.data.name);
//
//       print(value.data);
//       emit(RegisterSuccessState(loginModel));
//     }).catchError((error) {
//       print(error.toString());
//       emit(RegisterErrorState(error));
//     });
//   }
//
//   bool isPassword = true;
//   IconData icon = Icons.visibility_off_outlined;
//   void changePasswordVisibility() {
//     icon =
//         isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
//
//     isPassword = !isPassword;
//     emit(ChangeRegisterPasswordVisibilitySuccessState());
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/register/register_states.dart';
import 'package:shop_mart/model/login_model.dart';
import 'package:shop_mart/network/end_points.dart';
import 'package:shop_mart/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel loginModel;

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(RegisterLoadingState());

    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      //   print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      //print(loginModel.data.name);
      emit(RegisterSuccessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  IconData icon = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    icon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangeRegisterPasswordVisibilitySuccessState());
  }
}
