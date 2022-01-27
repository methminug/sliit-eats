import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/helpers/constants.dart';
import 'package:sliit_eats/models/general/sucess_message.dart';
import 'package:sliit_eats/models/order.dart';
import 'package:sliit_eats/models/product.dart';
import 'package:sliit_eats/routes/app_routes.dart';
import 'package:sliit_eats/screens/widgets/alert_dialog.dart';
import 'package:sliit_eats/screens/widgets/loading_screen.dart';
import 'package:sliit_eats/screens/widgets/no_data_component.dart';
import 'package:sliit_eats/services/order_service.dart';
import 'package:sliit_eats/services/product_service.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key, required this.isAdminView, required this.filters})
      : super(key: key);
  final dynamic filters;
  final bool isAdminView;

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  dynamic progress;

  Future<dynamic> _refresh() async {
    setState(() {});
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: ProgressHUD(
        child: Builder(builder: (context) {
          progress = ProgressHUD.of(context);
          return FutureBuilder(
            future: OrderService.getOrders(filters: widget.filters),
            builder:
                (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Duration minutesPassed = DateTime.now().difference(
                            DateTime.fromMillisecondsSinceEpoch(snapshot
                                .data![index]
                                .createdAt
                                .millisecondsSinceEpoch));
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20, top: 10, right: 20, bottom: 10),
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
                                  color: AppColors.cardColor.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        future: ProductService.getProductById(
                                            snapshot.data![index].productId),
                                        builder: (BuildContext context,
                                            AsyncSnapshot productSnapshot) {
                                          if (productSnapshot.hasData) {
                                            Product thisProduct =
                                                productSnapshot.data;
                                            return Text(
                                              '${thisProduct.name}    X    ${snapshot.data![index].quantity}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            );
                                          } else
                                            return SizedBox();
                                        }),
                                    widget.isAdminView
                                        ? Text(
                                            snapshot.data![index].username,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          )
                                        : Container(),
                                    Text(
                                      '${TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].createdAt.millisecondsSinceEpoch)).format(context)}  |  ${snapshot.data![index].createdAt.toDate().toLocal().toString().substring(0, 10)}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    Spacer(),
                                    minutesPassed.inMinutes <= 60.0
                                        ? Stack(
                                            children: [
                                              Container(
                                                color: Colors.grey[600],
                                                height: 5.0,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                              ),
                                              Container(
                                                color: AppColors.success,
                                                height: 5.0,
                                                width: (minutesPassed
                                                            .inMinutes /
                                                        Constants
                                                            .expirationPeriod) *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                              )
                                            ],
                                          )
                                        : SizedBox()
                                  ],
                                ),
                                Spacer(),
                                snapshot.data![index].status ==
                                        Constants.orderStatus[1]
                                    ? GestureDetector(
                                        onTap: () {
                                          showConfirmDialog(context, () async {
                                            dynamic res = await OrderService
                                                .updateOrderStatus(
                                              snapshot.data![index].id,
                                              snapshot.data![index].productId,
                                              true,
                                              snapshot.data![index].quantity,
                                            );
                                            if (res is SuccessMessage) {
                                              Navigator.pop(context);
                                              Navigator.popAndPushNamed(context,
                                                  AppRoutes.ORDER_MANAGEMENT,
                                                  arguments: {
                                                    'title': 'Active Orders',
                                                    'status':
                                                        Constants.orderStatus[1]
                                                  });
                                              await showCoolAlert(
                                                  context, true, res.message);
                                            } else
                                              await showCoolAlert(
                                                  context, false, res.message);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent[400],
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(0),
                                              bottomLeft: Radius.circular(0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 25,
                                            )),
                                          ),
                                        ),
                                      )
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
        }),
      ),
    );
  }
}
