import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:provider/provider.dart';


class CategoriesPage extends StatefulWidget{
    final String categories;
    CategoriesPage (@required this.categories);
  @override
  _CategoriesPageState createState() => _CategoriesPageState();

}

class _CategoriesPageState extends State<CategoriesPage> {


  @override
  Widget build(BuildContext context)
  {   FoodNotifier foodNotifier =
             Provider.of<FoodNotifier>(context , listen: false);
    List<Food> cart = [];
       foodNotifier.foodList.forEach((element) {
    if (element.category == widget.categories) {
      cart.add(element);
    }
  });
  print(cart.length);
       return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Center(child: Text(widget.categories),),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(returnPage: 0,)),
                );
              },
            ),
          ),
          body:  Container(

           child: ClipRRect(
             child: GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate:
                 SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                        )
                        );
                      }
}