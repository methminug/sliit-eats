import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/helpers/constants.dart';
import 'package:sliit_eats/routes/app_routes.dart';
import 'package:sliit_eats/screens/home_screen/components/option_card.dart';
import 'package:sliit_eats/screens/widgets/loading_screen.dart';

class ManagementTab extends StatefulWidget {
  const ManagementTab({Key? key}) : super(key: key);

  @override
  _ManagementTabState createState() => _ManagementTabState();
}

class _ManagementTabState extends State<ManagementTab> {
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => {
                                    Navigator.pushNamed(
                                        context, AppRoutes.PRODUCT_MANAGEMENT)
                                  },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: OptionCard(
                                    title: "",
                                    subtitle: "Product Management",
                                    icon: Icons.emoji_food_beverage,
                                    iconSize: 30),
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.CATEGORY_MANAGEMENT);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: OptionCard(
                                  title: "",
                                  subtitle: "Category Management",
                                  icon: Icons.category,
                                  iconSize: 30),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.USER_MANAGEMENT);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OptionCard(
                              title: "",
                              subtitle: "User Management",
                              icon: FontAwesomeIcons.users),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.ORDER_MANAGEMENT, arguments: {
                            'title': 'Active Orders',
                            'status': Constants.orderStatus[1]
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OptionCard(
                              title: "0",
                              subtitle: "Active Orders",
                              icon: null),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.ORDER_MANAGEMENT, arguments: {
                            'title': 'Served Orders',
                            'status': Constants.orderStatus[2]
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OptionCard(
                              title: "0",
                              subtitle: "Served Orders",
                              icon: null),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
