import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/helpers/constants.dart';
import 'package:sliit_eats/models/order.dart';
import 'package:sliit_eats/models/product.dart';
import 'package:sliit_eats/models/user.dart';
import 'package:sliit_eats/screens/management/order_management/components/order_expiration_display.dart';
import 'package:sliit_eats/screens/widgets/loading_screen.dart';
import 'package:sliit_eats/screens/widgets/no_data_component.dart';
import 'package:sliit_eats/services/auth_service.dart';
import 'package:sliit_eats/services/order_service.dart';
import 'package:sliit_eats/services/product_service.dart';

class MyOrdersTab extends StatefulWidget {
  const MyOrdersTab({Key? key}) : super(key: key);

  @override
  _MyOrdersTabState createState() => _MyOrdersTabState();
}

class _MyOrdersTabState extends State<MyOrdersTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  dynamic progress;

  Future<dynamic> _refresh() async {
    setState(() {});
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ProgressHUD(
          child: Builder(builder: (context) {
            progress = ProgressHUD.of(context);
            return FutureBuilder(
              future: AuthService.getCurrentUserDetails(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return FutureBuilder(
                    future: OrderService.getOrders(filters: [
                      {'name': 'user_id', 'value': snapshot.data!.userId},
                      {'name': 'status', 'value': Constants.orderStatus[1]}
                    ]),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Order>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        right: 20,
                                        bottom: 10),
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.cardColor,
                                          AppColors.cardColor,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.cardColor
                                              .withOpacity(0.2),
                                          blurRadius: 12,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 15),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ID : ${snapshot.data![index].id}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: AppColors.success,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            FutureBuilder(
                                                future: ProductService
                                                    .getProductById(snapshot
                                                        .data![index]
                                                        .productId),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot
                                                        productSnapshot) {
                                                  if (productSnapshot.hasData) {
                                                    Product thisProduct =
                                                        productSnapshot.data;
                                                    return Text(
                                                      '${thisProduct.name}    X    ${snapshot.data![index].quantity}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    );
                                                  } else
                                                    return SizedBox();
                                                }),
                                            Text(
                                              '${TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].createdAt.millisecondsSinceEpoch)).format(context)}  |  ${snapshot.data![index].createdAt.toDate().toLocal().toString().substring(0, 10)}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        snapshot.data![index].status ==
                                                Constants.orderStatus[1]
                                            ? OrderExpirationDisplay(
                                                createdDateTime: snapshot
                                                    .data![index].createdAt)
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return NoDataComponent();
                        }
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
    );
  }
}
