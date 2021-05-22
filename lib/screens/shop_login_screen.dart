import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/login/login_cubit.dart';
import 'package:shop_mart/cubit/login/login_states.dart';
import 'package:shop_mart/network/local/cache_helper.dart';
import 'package:shop_mart/screens/home_screen.dart';
import 'package:shop_mart/screens/register_screen.dart';
import 'package:shop_mart/widgets/components.dart';
import 'package:shop_mart/widgets/constants.dart';

class ShopLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          // if (state is LoginSuccessState) {
          //   if (state.loginModel.status) {
          //     print(state.loginModel.message);
          //     print(state.loginModel.status);
          //     print(state.loginModel.data.token);
          //     showToast(
          //         text: state.loginModel.message, state: ToastStates.SUCCESS);
          //   } else {
          //     showToast(
          //         text: state.loginModel.message, state: ToastStates.ERROR);
          //     print(state.loginModel.message);
          //   }
          // }

          if (state is LoginSuccessState) {
            if (state.loginModel.status) {
              print(state.loginModel.message);
              print(state.loginModel.data.token);

              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data.token,
              ).then((value) {
                token = state.loginModel.data.token;

                navigateAndFinish(
                  context,
                  HomeScreen(),
                );
              });
            } else {
              print(state.loginModel.message);

              showToast(
                text: state.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Buy it, don\'t think twice',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Email Address Can\'t be empty';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            onSubmit: (val) {
                              submit(
                                  cubit, emailController, passwordController);
                            },
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPassword,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Password Can\'t be empty';
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: cubit.icon,
                            suffixPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        SizedBox(
                          height: 25.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                submit(
                                    cubit, emailController, passwordController);

                                //  navigateTo(context, HomeScreen());
                              },
                              text: 'Login'),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'don\'t have account yet ?',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            defaultTextButton(
                                function: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                text: 'Register')
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void submit(LoginCubit cubit, TextEditingController emailController,
      TextEditingController passwordController) {
    if (formKey.currentState.validate()) {
      cubit.userLogin(
          email: emailController.text, password: passwordController.text);
    }
  }
}
