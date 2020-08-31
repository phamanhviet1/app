import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:flutter_food_delivery/pages/CategoriesPage.dart';
import 'package:flutter_food_delivery/pages/ProfilePage.dart';
import 'package:flutter_food_delivery/pages/HomePage.dart';
import 'package:flutter_food_delivery/pages/OrderPage.dart';
import 'package:flutter_food_delivery/pages/Admin.dart';
import 'package:flutter_food_delivery/pages/SignInPage.dart';
import 'package:provider/provider.dart';
class MainScreen extends StatefulWidget{

  final int returnPage;

  MainScreen ({ this.returnPage});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{


  int currentTabIndex = 0;
  List <Widget> pages;
  Widget currentPage;
  HomePage homePage;
  OrderPage orderPage;
  ProfilePage  profilePage;
  AdminPage adminPage;
  SignInPage signInPage;
  CategoriesPage categoriesPage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePage = HomePage();
    orderPage = OrderPage();
    profilePage = ProfilePage();
    adminPage = AdminPage();
    categoriesPage =CategoriesPage();
    signInPage = SignInPage();
    pages=[ homePage , orderPage, adminPage , profilePage ];
    currentPage= pages[widget.returnPage];
    currentTabIndex =widget.returnPage;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context , listen: false);
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
              currentPage = pages[index];
            });
          },
          currentIndex: currentTabIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.home),
                ),
                title: Text("Home")),
            BottomNavigationBarItem(
                icon: Stack(children:<Widget> [Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.shopping_cart),
                ),
                   Positioned(right: 0,top: 0,child: Container( decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(40)),
                    child: Text(" ${foodNotifier.cardList.length} ")))
                ]),
                title: Text("Order")),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.security),
                ),
                title: Text("Admin")),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.person),
                ),
                title: Text("Profile")),

          ]
      ),
    );
  }
}

