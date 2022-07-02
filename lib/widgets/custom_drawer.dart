
import 'package:book_a_table/controllers/general_controller.dart';
import 'package:book_a_table/modules/all_orders/view.dart';
import 'package:book_a_table/modules/home/logic.dart';
import 'package:book_a_table/modules/home/state.dart';
import 'package:book_a_table/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyCustomDrawer extends StatefulWidget {
  const MyCustomDrawer({Key? key}) : super(key: key);

  @override
  _MyCustomDrawerState createState() => _MyCustomDrawerState();
}

class _MyCustomDrawerState extends State<MyCustomDrawer> {
  final HomeLogic logic = Get.find<HomeLogic>();
  final HomeState state = Get.find<HomeLogic>().state;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .15,
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.profile);
            },
            leading: SvgPicture.asset('assets/drawerProfileIcon.svg'),
            title: Text('Profile', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.to(const AllOrdersPage(
                backNormal: true,
              ));
            },
            leading: SvgPicture.asset('assets/drawerCartIcon.svg'),
            title: Text('Orders', style: state.drawerTitleTextStyle),
          ),
           ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.myBooking);
            },
            leading: Container(
              padding: EdgeInsets.only(right: 5),
              height: 34,width: 34,
              child: SvgPicture.asset('assets/booking.svg',color: Colors.white,)),
            title: Text('Bookings', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.coupons);
            },
            leading: SvgPicture.asset('assets/drawerOfferIcon.svg'),
            title: Text('Coupons', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.favourites);
            },
            leading: SvgPicture.asset('assets/Favourites.svg'),
            title: Text('Favourites', style: state.drawerTitleTextStyle),
          ),
        
        
         
          const Spacer(),
          ListTile(
            onTap: () {
              Get.find<GeneralController>().firebaseAuthentication.signOut();
            },
            title: Row(
              children: [
                Text('Sign-out', style: state.drawerTitleTextStyle),
                const Icon(
                  Icons.arrow_forward_sharp,
                  color: Colors.white,
                  size: 25,
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
        ],
      ),
    );
  }
}
