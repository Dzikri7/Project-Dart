import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shoes_app/controllers/favorites_provider.dart';
import 'package:online_shoes_app/controllers/login_provider.dart';
import 'package:online_shoes_app/controllers/product_provider.dart';
import 'package:online_shoes_app/models/sneaker_model.dart';
import 'package:online_shoes_app/services/helper.dart';
import 'package:online_shoes_app/views/shared/appstyle.dart';
import 'package:online_shoes_app/views/shared/home_widget.dart';
import 'package:online_shoes_app/views/shared/reuseable_text.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorites_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  late Future<List<Sneakers>> _male;
  late Future<List<Sneakers>> _female;
  late Future<List<Sneakers>> _kids;

  void getMale() {
    _male = Helper().getMaleSneakers();
  }

  void getFemale() {
    _female = Helper().getFemaleSneakers();
  }

  void getKids() {
    _kids = Helper().getKidsSneakers();
  }


  @override
  void initState() {
    super.initState();
    getMale();
    getFemale();
    getKids();
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    authNotifier.getPrefs();
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: 812.h,
        width: 375.w,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 45.h, 0, 0),
              height: 325.h,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/top_image.png"),
                      fit: BoxFit.cover)),
              child: Container(
                padding: EdgeInsets.only(left: 8.w, bottom: 15.h),
                width: 375.w,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText(
                        text: "Athletics Shoes",
                        style: appstyleWithHt(
                            42, Colors.white, FontWeight.bold, 1.5),
                      ),
                      reusableText(
                        text: "Collection",
                        style: appstyleWithHt(
                            42, Colors.white, FontWeight.bold, 1.2),
                      ),
                      TabBar(
                        padding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.transparent,
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.white,
                        labelStyle: appstyle(24, Colors.white, FontWeight.bold),
                        unselectedLabelColor: Colors.grey.withOpacity(0.3),
                        tabs: const [
                          Tab(
                            text: "Men Shoes",
                          ),
                          Tab(
                            text: "Women Shoes",
                          ),
                          Tab(
                            text: "Kids Shoes",
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 203.h),
              child: Container(
                padding: EdgeInsets.only(left: 12.w),
                child: TabBarView(controller: _tabController, children: [
                  HomeWidget(
                    male: _male,
                    tabIndex: 0,
                  ),
                  HomeWidget(
                    male: _female,
                    tabIndex: 1,
                  ),
                  HomeWidget(
                    male: _kids,
                    tabIndex: 2,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
