import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/home/home_cubit.dart';
import 'package:shop_mart/cubit/home/home_states.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Column(
          children: [
            ConditionalBuilder(
              condition: cubit.homeModel != null,
              builder: (context) => BuildBanners(cubit: cubit),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      },
    );
  }
}

class BuildBanners extends StatelessWidget {
  const BuildBanners({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: cubit.homeModel.data.banners
          .map(
            (e) => Image(
              image: NetworkImage('${e.image}'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
          .toList(),
      options: CarouselOptions(
        enableInfiniteScroll: true,
        height: 170,
        autoPlay: true,
        initialPage: 0,
        reverse: false,
        viewportFraction: 1.0,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayCurve: Curves.fastLinearToSlowEaseIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
