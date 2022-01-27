import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/models/product.dart';
import 'package:sliit_eats/screens/product/components/product_order_modal.dart';
import 'package:sliit_eats/screens/widgets/loading_screen.dart';
import 'package:sliit_eats/screens/widgets/rounded_button.dart';
import 'package:sliit_eats/services/canteen_service.dart';
import 'package:sliit_eats/services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  dynamic progress;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _refresh() async {
    setState(() {});
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundGradient['top']!,
              AppColors.backgroundGradient['bottom']!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: ProgressHUD(
            child: Builder(builder: (context) {
              progress = ProgressHUD.of(context);
              return FutureBuilder(
                future: ProductService.getProductById(args['product_id']),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    Product thisProduct = snapshot.data;
                    return FutureBuilder(
                      future:
                          CanteenService.getCanteenName(thisProduct.canteen),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          String canteenName = snapshot.data;
                          return Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 40),
                                Hero(
                                  tag: thisProduct.id,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.55,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image:
                                                Image.network(thisProduct.image)
                                                    .image,
                                            fit: BoxFit.cover)),
                                    child: Column(
                                      children: [
                                        Spacer(),
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(35),
                                              topRight: Radius.circular(35),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 4, sigmaY: 4),
                                            child: Container(
                                              height: 130,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      thisProduct.name,
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                          letterSpacing: 2),
                                                    ),
                                                    thisProduct.unitsLeft > 0
                                                        ? Text(
                                                            "${thisProduct.unitsLeft} left",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    2),
                                                          )
                                                        : Text(
                                                            "OUT of stock",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .red[600],
                                                                letterSpacing:
                                                                    2),
                                                          ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[850],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Text(
                                                          canteenName,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Flexible(
                                  child: Text(
                                    thisProduct.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Serves  ${thisProduct.servings}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Price",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              "Rs. ",
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            Text(
                                              thisProduct.unitPrice
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  letterSpacing: 2),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    RoundedButton(
                                        text: 'Reserve Now',
                                        buttonColor: AppColors.primary,
                                        onPressed: () {
                                          return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ProductOrderModal(
                                                  productId: thisProduct.id,
                                                  name: thisProduct.name,
                                                  price: thisProduct.unitPrice
                                                      .toDouble(),
                                                  unitsLeft:
                                                      thisProduct.unitsLeft,
                                                );
                                              });
                                        })
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return LoadingIndicator();
                        }
                      },
                    );
                  } else {
                    return LoadingIndicator();
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
