import 'package:chat_app/services/auth_service.dart';
import 'package:get/get.dart';

class homeController extends GetxController {
  RxString userName = "User".obs;
  RxString email = "user@gmail.com".obs;
  RxString image =
      "https://tse4.mm.bing.net/th?id=OIP.Yaficbwe3N2MjD2Sg0J9OgHaHa&pid=Api&P=0&h=180"
          .obs;

  void fatchuserData() {
    var user = AuthService.authService.currentUser;

    if (user != null) {
      userName.value = user.displayName ?? user.email?.split('@')[0] ?? "Dummy";
      email.value = user.email ?? "dummy@gmail.com";
      image.value = user.photoURL ??
          "https://tse4.mm.bing.net/th?id=OIP.Yaficbwe3N2MjD2Sg0J9OgHaHa&pid=Api&P=0&h=180";
    }
  }
}
