import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive/hive.dart';
import 'package:online_shoes_app/controllers/favorites_provider.dart';
import 'package:online_shoes_app/controllers/login_provider.dart';
import 'package:online_shoes_app/models/constants.dart';
import 'package:online_shoes_app/views/shared/appstyle.dart';
import 'package:online_shoes_app/views/shared/reuseable_text.dart';
import 'package:online_shoes_app/views/ui/auth/login.dart';
import 'package:online_shoes_app/views/ui/favorites.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {super.key,
      required this.price,
      required this.category,
      required this.id,
      required this.name,
      required this.image});

  final String price;
  final String category;
  final String id;
  final String name;
  final String image;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _favBox = Hive.box('fav_box');

  Future<void> _createFav(Map<String, dynamic> addFav) async {

  }

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(context, listen: true);
    favoritesNotifier.getFavorites();
    bool selected = true;

    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 20.w),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          height: 325.h,
          width: 225.w,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 0.6,
                offset: Offset(1, 1))
          ]),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 186.h,
                      decoration: BoxDecoration(
                          image:
                              DecorationImage(image: NetworkImage(widget.image))),
                    ),
                    Positioned(
                      right: 10.w,
                      top: 10.h,
                      child: Consumer<FavoritesNotifier>(
                        builder: (context, favoritesNotifier, child) {
                          return Consumer<LoginNotifier>(
                              builder: (context, authNotifier, child) {
                                return GestureDetector(
                                  onTap: () async {
                                    if(authNotifier.loggeIn == true) {
                                      if(favoritesNotifier.ids.contains(widget.id)){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const Favorites()));
                                      }else {
                                        _createFav({
                                          "id": widget.id,
                                          "name": widget.name,
                                          "category": widget.category,
                                          "price": widget.price,
                                          "imageUrl": widget.image
                                        });
                                      }
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                    }
                                  },
                                  child: favoritesNotifier.ids.contains(widget.id)? const Icon(AntDesign.heart):const Icon(AntDesign.hearto),
                                );
                              },
                            );
                        },
                    )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText(
                        text: widget.name,
                        style: appstyleWithHt(
                            30, Colors.black, FontWeight.bold, 1.1),
                      ),
                      reusableText(
                        text: widget.category,
                        style:
                            appstyleWithHt(16, Colors.grey, FontWeight.bold, 1.5),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reusableText(
                        text: widget.price,
                        style: appstyle(22, Colors.black, FontWeight.w600),
                      ),
                      Row(
                        children: [
                          reusableText(
                            text: "Colors",
                            style: appstyle(14, Colors.grey, FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          ChoiceChip(label: const Text(" "), 
                          selected: selected,
                          visualDensity: VisualDensity.compact,
                          selectedColor: Colors.black,
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
