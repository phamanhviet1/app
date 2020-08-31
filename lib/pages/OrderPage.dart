import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
class OrderPage extends StatefulWidget{


  @override
  _OrderPageState createState() => _OrderPageState();

}

class _OrderPageState extends State<OrderPage> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(child : Text('Shop Card')),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: 650,width: 400,
            child:
            ListView.separated(
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(foodNotifier.cardList[index].image, width: 120, fit: BoxFit.fitWidth,),
                  title: Text(foodNotifier.cardList[index].name),
                  subtitle: Text(foodNotifier.cardList[index].category),

                  onTap: () {
                    foodNotifier.orderFood = foodNotifier.cardList[index];
                    showAlertDialog(BuildContext context) {
                      // set up the buttons
                      Widget cancelButton = FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();

                        },
                      );
                      Widget continueButton = FlatButton(
                        child: Text("Delete"),
                        onPressed: () {
                          foodNotifier.deleteCard(foodNotifier.orderFood);
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return MainScreen(returnPage: 1,);
                                  })
                          );
                        },
                      );

                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: Text("AlertDialog"),
                        content: Text(
                            "DO you like to Delete Item?"),
                        actions: [
                          cancelButton,
                          continueButton,
                        ],
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                    showAlertDialog(context);
                  },
                );
              },
              itemCount: foodNotifier.cardList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.black);
              },


            ),


          ),

          Container(
            width: 400.0,
            height: 60.0,
            child: Row(
              children: [
                Expanded(
                  child: ListTile(title: Text('Total :'),subtitle:
                  Text("\$ 200",style: TextStyle(fontSize: 20),),),
                ),
                Expanded(child: MaterialButton(onPressed: (){
                  String name = randomAlpha(5);

                  for(var i=0 ;i< foodNotifier.cardList.length ;i++)
                  {
                    foodNotifier.cardList[i].flag = name;
                    UploadOrderCard(foodNotifier.cardList[i],authNotifier.user.email);
                    print(i.toString());
                  }


                  for( var i=0 ;i < foodNotifier.cardList.length;)
                  {
                    foodNotifier.deleteCard(foodNotifier.cardList[i]);
                    print(foodNotifier.cardList.length);
                  }

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MainScreen(returnPage: 1,);
                      }));
                  },
                  child: Text('Check Out'),color: Colors.orange,),)
              ],),
          ),
        ],
      ),
    );

  }
}