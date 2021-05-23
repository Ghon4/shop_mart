import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/home/home_cubit.dart';
import 'package:shop_mart/cubit/home/home_states.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context).categoryModel;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemBuilder: (context, index) => Row(
              children: [
                Image(
                  width: 100.0,
                  height: 100.0,
                  image: NetworkImage('${cubit.data.data[index].image}'),
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 15.0),
                Text(
                  '${cubit.data.data[index].name}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ],
            ),
            separatorBuilder: (context, index) => SizedBox(height: 15.0),
            itemCount: cubit.data.data.length,
          ),
        );
      },
    );
  }
}
