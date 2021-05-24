import 'package:shop_mart/network/local/cache_helper.dart';
import 'package:shop_mart/screens/shop_login_screen.dart';

import 'components.dart';

String token = '';

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      navigateAndFinish(
        context,
        ShopLoginScreen(),
      );
    }
  });
}
