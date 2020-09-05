
import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/Screen/SplashScreen.dart';
import 'package:flutter_food_delivery/Widget/user_profile.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:flutter_food_delivery/notifier/ordernotifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:random_string/random_string.dart';
import '../models/Food.dart';
import 'package:toast/toast.dart';
import '../models/ListItem.dart';
import 'SignInPage.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String data;
  List<String> cartname =[];

  String _key;
  String foos = 'Select Cart';


  _collapse(String a) {
    String newKey;
      do {
      _key = randomNumeric(4);
      foos = a;
    } while (newKey == _key);
  }

  // ignore: missing_return

  @override
  void initState() {
    super.initState();
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context,listen: false);
    OrderNotifier orderNotifier =
    Provider.of<OrderNotifier>(context,listen:false);
    getOrder(orderNotifier, authNotifier.user.email ,cartname);


    _collapse(this.foos);

  }
  Widget _cart(){
    return Container(
      height: 500,

      child: Stack(
        children: [
          ListView.separated(
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(cartname[index]),
                onTap: () {
                  setState(() {
                    this.foos = cartname[index];
                    _collapse(this.foos);
                  });
                },
              );
            },
            itemCount: cartname.length,
            separatorBuilder: (BuildContext context, int index){
              return Divider(color: Colors.black);
            },

          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context,listen: false);
   OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context,);


      print("build");

      Widget _builderItem() {

      List<Food> cart = [];
      orderNotifier.orderList.forEach((element) {
        if (element.flag == foos) {
          cart.add(element);
        }
      });
      print(cart.length);
      return Container(
        height: 180,
        child: ClipRRect(
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(
                              cart[index].image,
                             height: 100,width: 300,
                              fit: BoxFit.fitHeight,
                            ),
                            Text(cart[index].name),
                            Text(cart[index].category),
                      ],
                    ),
                  )));
            },
            itemCount: cart.length,
          ),
        ),
      );
    }

          return Scaffold(

           appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: Text("Profile ")),
              actions:<Widget>[

                MaterialButton(
                    onPressed: () {
                      getOrder(orderNotifier, authNotifier.user.email,cartname);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) {
                        return MainScreen(
                          returnPage: 3,
                        );
                      }));
                      print("total ${orderNotifier.orderList.length}");
                    },
                    child: Icon(Icons.refresh)),
              ]
            ),

            body: Padding(
            padding: const EdgeInsets.all(8.0),
              child:  ListView(
              children: [

                UserProfile(),
                new RefreshIndicator(

                  child: ExpansionTile(

                    key: new Key(_key),
                    initiallyExpanded: false,
                    title: new Text(foos),
                    children: [
                      _cart(),

                    ],
                  ),
                  onRefresh: () async {
                    cartname=[];
                    await  getOrder(orderNotifier, authNotifier.user.email ,cartname);


                  },
                ),
                new RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh:() async {
                   },
                  child: _builderItem()
                ),
              ],
            ),
    )
    );
        // } else return SplashScreen();
      }
    }


