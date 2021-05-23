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
          condition: cubit.homeModel != null,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
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
          ),
          SizedBox(
            height: 5.0,
          ),
          GridView.count(
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
                              if (cubit.homeModel.data.products[index]
                                      .discount !=
                                  0)
                                Text(
                                  '${cubit.homeModel.data.products[index].oldPrice}',
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                              Spacer(),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite_border_outlined))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
