import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_mart/cubit/home/home_cubit.dart';
import 'package:shop_mart/cubit/home/home_states.dart';
import 'package:shop_mart/style/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null && cubit.categoryModel != null,
          builder: (context) => BuildProducts(cubit: cubit),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class BuildProducts extends StatelessWidget {
  const BuildProducts({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildBannerWidget(cubit: cubit),
            SizedBox(
              height: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                CategoryScrollWidget(cubit: cubit),
                SizedBox(height: 15.0),
                Text(
                  'Products',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            BuildProductsGrid(cubit: cubit),
          ],
        ),
      ),
    );
  }
}

class CategoryScrollWidget extends StatelessWidget {
  const CategoryScrollWidget({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image(
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
                image: NetworkImage(
                    '${cubit.categoryModel.data.data[index].image}')),
            Container(
              width: 100,
              color: Colors.black54,
              child: Text(
                '${cubit.categoryModel.data.data[index].name}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        separatorBuilder: (context, index) => SizedBox(width: 5.0),
        itemCount: cubit.categoryModel.data.data.length,
      ),
    );
  }
}

class BuildProductsGrid extends StatelessWidget {
  const BuildProductsGrid({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      childAspectRatio: 1 / 1.8,
      crossAxisCount: 2,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 5.0,
      children: List.generate(
        cubit.homeModel.data.products.length,
        (index) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image(
                      image: NetworkImage(
                          cubit.homeModel.data.products[index].image),
                      width: double.infinity,
                      // fit: BoxFit.cover,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Discount',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Column(
                  children: [
                    Text('${cubit.homeModel.data.products[index].name}'),
                    Row(
                      children: [
                        Text(
                          '${cubit.homeModel.data.products[index].price}',
                          style: TextStyle(
                            color: defaultColor,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        if (cubit.homeModel.data.products[index].discount != 0)
                          Text(
                            '${cubit.homeModel.data.products[index].oldPrice}',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                        Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            cubit.changeFavorites(
                                cubit.homeModel.data.products[index].id);
                          },
                          icon: CircleAvatar(
                            backgroundColor: cubit.favorites[
                                    cubit.homeModel.data.products[index].id]
                                ? defaultColor
                                : Colors.grey,
                            radius: 16.0,
                            child: Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildBannerWidget extends StatelessWidget {
  const BuildBannerWidget({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: cubit.homeModel.data.banners
          .map(
            (e) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${e.image}'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
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
