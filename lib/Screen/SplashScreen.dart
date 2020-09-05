import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/ordernotifier.dart';
import 'package:provider/provider.dart';
import '../notifier/foodnotifier.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context,listen: false);
    OrderNotifier orderNotifier =
    Provider.of<OrderNotifier>(context, );
    getInfor(orderNotifier, authNotifier.user.email);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Initialization",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}