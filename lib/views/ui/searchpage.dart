import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:online_shoes_app/controllers/product_provider.dart';
import 'package:online_shoes_app/models/sneaker_model.dart';
import 'package:online_shoes_app/services/helper.dart';
import 'package:online_shoes_app/views/shared/appstyle.dart';
import 'package:online_shoes_app/views/shared/custom_field.dart';
import 'package:online_shoes_app/views/shared/export_packages.dart';
import 'package:online_shoes_app/views/shared/reusable_text.dart';
import 'package:online_shoes_app/views/ui/product_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.h,
        backgroundColor: Colors.black,
        elevation: 0,
        title: CustomField(
          hintText: 'Search for a product',
          controller: search,
          onEditingComplete: () {
            setState(() {});
          },
          prefixIcon: GestureDetector(
            onTap: () {},
            child: const Icon(AntDesign.camera, color: Colors.black,),
          ),

          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {

              });
            },
            child: const Icon(AntDesign.search1, color: Colors.black,),
          ),
        ),
      ),
      body: search.text.isEmpty
          ? Container(
              height: 600.h,
              padding: EdgeInsets.all(20.h),
              margin: EdgeInsets.only(right: 50.w),
              child: Image.asset('assets/images/Pose23.png'),
      ): FutureBuilder<List<Sneakers>>(
        future: Helper().search(search.text),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: ReusableText(
                text: 'Error Retrieving The Data',
                style: appstyle(20, Colors.black, FontWeight.bold)),
            );
          } else if (snapshot.data!.isEmpty){
            return Center(
              child: ReusableText(
                  text: 'Product Not Found',
                  style: appstyle(20, Colors.black, FontWeight.bold)),
            );
          }else {
            final shoes = snapshot.data;
            return ListView.builder(
                itemCount: shoes!.length,
                itemBuilder: ((context, index) {
                  final shoe = shoes[index];
                  return GestureDetector(
                    onTap: () {
                      productProvider.shoesSizes = shoe.sizes;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductPage(sneakers: shoe)));
                    },
                    child: Padding(padding: EdgeInsets.all(8.h),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        height: 100.h,
                        width: 325.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              spreadRadius: 5,
                              blurRadius: 0.3,
                              offset: const Offset(0, 1)
                            )
                          ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.all(12.h),
                            child: CachedNetworkImage(
                              imageUrl: shoe.imageUrl[0],
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.cover,
                            ),
                            ),
                            
                            Padding(padding: EdgeInsets.only(top: 12.h, left: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReusableText(text: shoe.name,
                                    style: appstyle(16, Colors.black, FontWeight.w600)),

                                const SizedBox(
                                  height: 5,
                                ),

                                ReusableText(text: shoe.category,
                                    style: appstyle(13, Colors.grey.shade600, FontWeight.w600)),

                                const SizedBox(
                                  height: 5,
                                ),

                                ReusableText(text: "\$ ${shoe.price}",
                                    style: appstyle(13, Colors.grey.shade600, FontWeight.w600)),
                              ],
                            ),
                            )
                          ],
                        ),
                      ),
                    ),),
                  );
                }));
          }
        },
      )
    );
  }
}