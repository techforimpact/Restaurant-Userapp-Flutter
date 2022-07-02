
import 'package:book_a_table/modules/home/view.dart';
import 'package:book_a_table/modules/my_bookings/view.dart';
import 'package:book_a_table/modules/on_board/view.dart';
import 'package:book_a_table/modules/search/view.dart';
import 'package:book_a_table/modules/splash/view.dart';
import 'package:get/get.dart';

import 'modules/all_orders/view.dart';
import 'modules/cart/view.dart';
import 'modules/coupons/view.dart';
import 'modules/edit_profile/view.dart';
import 'modules/favourites/view.dart';
import 'modules/forget_password.dart/view.dart';
import 'modules/login/view.dart';
import 'modules/login/view_phone_login.dart';
import 'modules/map/view.dart';
import 'modules/notifactions/view.dart';
import 'modules/payment/view.dart';
import 'modules/pending_review/view.dart';
import 'modules/product_detail/view.dart';
import 'modules/saved_cards/view.dart';
import 'modules/sign_up/view.dart';
import 'modules/profile/view.dart';


routes() => [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/login", page: () => const LoginPage()),
      GetPage(name: "/phoneLogin", page: () => const PhoneLoginView()),
      GetPage(name: "/signUp", page: () => const SignUpPage()),
      GetPage(name: "/MyBooking", page: () => const AllBookingPage()),
      GetPage(name: "/home", page: () => const Home()),

      GetPage(name: "/productDetail", page: () => const ProductDetailPage()),
      // GetPage(
      //     name: "/restaurantDetail", page: () => const RestaurantDetailPage()),
      GetPage(name: "/cart", page: () => const CartPage()),
      GetPage(name: "/search", page: () => const SearchPage()),
      GetPage(name: "/payment", page: () {return const PaymentPage();}),
      GetPage(name: "/allOrders", page: () => const AllOrdersPage()),
      GetPage(name: "/profile", page: () => const ProfilePage()),
      GetPage(name: "/editProfile", page: () => const EditProfilePage()),
      GetPage(name: "/pendingReview", page: () => const PendingReviewPage()),
      // GetPage(name: "/help", page: () => const HelpPage()),
      GetPage(name: "/coupons", page: () => const CouponsPage()),
      // GetPage(name: "/privacyPolicy", page: () => const PrivacyPolicyPage()),
      GetPage(name: "/favourites", page: () => const FavouritesPage()),
      GetPage(name: "/savedCards", page: () => const SavedCardsPage()),
      GetPage(name: "/notifications", page: () => const NotificationsPage()),
      GetPage(name: "/onBoard", page: () => const OnBoarding()),
      GetPage(name: "/map", page: () => const MapPage()),
      GetPage(name: "/forgetPassword", page: () => const ForgotPassword()),
    ];

class PageRoutes {
  static const String splash = '/splash';
  static const String search = '/search';
  static const String myBooking = '/MyBooking';
  static const String login = '/login';
  static const String phoneLogin = '/phoneLogin';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String productDetail = '/productDetail';
  static const String restaurantDetail = '/restaurantDetail';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String allOrders = '/allOrders';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';
  static const String pendingReview = '/pendingReview';
  static const String help = '/help';
  static const String coupons = '/coupons';
  static const String privacyPolicy = '/privacyPolicy';
  static const String favourites = '/favourites';
  static const String savedCards = '/savedCards';
  static const String notifications = '/notifications';
  static const String onBoard = '/onBoard';
  static const String map = '/map';
  static const String preferences = '/preferences';
  static const String forgetPassword = '/forgetPassword';

 
}
