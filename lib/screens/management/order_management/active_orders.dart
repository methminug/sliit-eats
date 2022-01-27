import 'package:flutter/material.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/screens/management/order_management/components/order_list.dart';
import 'package:sliit_eats/screens/widgets/custom_appbar.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({Key? key}) : super(key: key);

  @override
  _OrderManagementState createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: customAppBar(
          title: args['title'],
          showBackArrow: true,
          onBackPressed: () => Navigator.of(context).pop()),
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
        child: OrderList(isAdminView: true, filters: [
          {'name': 'status', 'value': args['status']}
        ]),
      ),
    );
  }
}
