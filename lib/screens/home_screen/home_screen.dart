import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/models/user.dart';
import 'package:sliit_eats/screens/home_screen/components/custom_tab.dart';
import 'package:sliit_eats/screens/home_screen/tabs/my_orders.dart';
import 'package:sliit_eats/screens/home_screen/tabs/browse.dart';
import 'package:sliit_eats/screens/home_screen/tabs/management.dart';
import 'package:sliit_eats/screens/user/profile_screen/profile_screen.dart';
import 'package:sliit_eats/screens/widgets/loading_screen.dart';
import 'package:sliit_eats/services/auth_service.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool firstRender = true;

  List<Widget> getTabs(UserModel? user) {
    List<Widget> tabs = [];
    tabs.add(CustomTab(icon: FontAwesomeIcons.home, size: 20, name: "Home"));
    if (user!.isAdmin)
      tabs.add(CustomTab(
          icon: FontAwesomeIcons.plusCircle, size: 20, name: "Management"));
    tabs.add(CustomTab(
        icon: FontAwesomeIcons.solidCalendar, size: 20, name: "My Orders"));
    return tabs;
  }

  List<Widget> getTabbarContent(UserModel? user) {
    List<Widget> tabContent = [];
    tabContent.add(BrowseTab());
    if (user!.isAdmin) tabContent.add(ManagementTab());
    tabContent.add(MyOrdersTab());
    return tabContent;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<UserModel?> readUserData() async {
    UserModel? user = await AuthService.getCurrentUserDetails();
    return user;
  }

  void initializeTabController(UserModel? user, int initialIndex) {
    if (firstRender) {
      firstRender = false;
      _tabController = TabController(
        vsync: this,
        initialIndex: initialIndex,
        length: user!.isAdmin ? 3 : 2,
      );
    }
  }

  Future<bool> onBackPressed() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return WillPopScope(
        onWillPop: onBackPressed,
        child: ProgressHUD(
          child: Builder(
            builder: (context) {
              return FutureBuilder<UserModel?>(
                future: readUserData(),
                builder:
                    (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                  if (snapshot.hasData) {
                    initializeTabController(
                        snapshot.data, args['selectedTabIndex']);
                    return Scaffold(
                      key: _scaffoldKey,
                      endDrawerEnableOpenDragGesture: false,
                      endDrawer: ProfileSettings(),
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: AppColors.backgroundGradient['top'],
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3, 0, 40, 0),
                              child: Text(
                                "What's Cooking ?",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                              child: Transform(
                                transform: Matrix4.rotationY(math.pi),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Lottie.asset(
                                    "assets/animations/home_screen/burger.json",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _scaffoldKey.currentState!.openEndDrawer();
                                });
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                child: Image.asset(
                                    "assets/images/menuIconProfile.png"),
                              ),
                            ),
                          )
                        ],
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: getTabbarContent(snapshot.data),
                      ),
                      bottomNavigationBar: BottomAppBar(
                        elevation: 0,
                        color: Colors.black,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 1.5,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          height: 70,
                          child: TabBar(
                            controller: _tabController,
                            unselectedLabelColor: Colors.white54,
                            labelColor: AppColors.primary,
                            labelPadding: EdgeInsets.all(0),
                            indicatorPadding: EdgeInsets.all(0),
                            indicatorColor: AppColors.primary,
                            tabs: getTabs(snapshot.data),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return LoadingIndicator();
                  }
                },
              );
            },
          ),
        ));
  }
}
