import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/home/home_cubit.dart';
import 'package:shop_mart/cubit/home/home_states.dart';
import 'package:shop_mart/widgets/components.dart';
import 'package:shop_mart/widgets/constants.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        nameController.text = cubit.loginModel.data.name;
        emailController.text = cubit.loginModel.data.email;
        phoneController.text = cubit.loginModel.data.phone;

        return Column(
          children: [
            Text(
              'Profile',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 25),
            ),
            SizedBox(
              height: 25.0,
            ),
            defaultFormField(
                controller: nameController,
                type: TextInputType.name,
                validate: (String value) {
                  if (value.isEmpty) {
                    return 'Name can\'t be empty';
                  }
                },
                label: 'name',
                prefix: Icons.person_outline_rounded),
            SizedBox(
              height: 20.0,
            ),
            defaultFormField(
                controller: emailController,
                type: TextInputType.emailAddress,
                validate: (String value) {
                  if (value.isEmpty) {
                    return 'Email address can\'t be empty';
                  }
                },
                label: 'Email address',
                prefix: Icons.email_outlined),
            SizedBox(
              height: 20.0,
            ),
            defaultFormField(
                controller: phoneController,
                type: TextInputType.phone,
                validate: (String value) {
                  if (value.isEmpty) {
                    return 'Phone can\'t be empty';
                  }
                },
                label: 'Phone',
                prefix: Icons.phone_outlined),
            SizedBox(
              height: 20.0,
            ),
            defaultButton(
                function: () {
                  signOut(context);
                },
                text: 'Log Out')
          ],
        );
      },
    );
  }
}
