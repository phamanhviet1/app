
import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/models/Product.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:provider/provider.dart';
class ProductFood extends StatefulWidget {
  @override
  _ProductFoodState createState() => _ProductFoodState();
}

class _ProductFoodState extends State<ProductFood>{
  List<Food> filteredUsers =[];
  @override
  void initState() {
    // TODO: implement initState
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context,listen: false );
    getFoods(foodNotifier);
    Future.delayed(Duration(milliseconds: 750)).then((_) {
      filteredUsers = foodNotifier.foodList;
    });


  }

  @override
  Widget build(BuildContext context) {

      FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, );
      getFoods(foodNotifier);

    // TODO: implement build
    return
       Column(
         children: [
           Container(

               decoration: BoxDecoration(
                   color: Colors.white,
                   boxShadow: [BoxShadow(
                       color: Colors.grey,
                       offset: Offset(1, 1),
                       blurRadius: 4
                   )],
                   borderRadius: BorderRadius.circular(20)
               ),
               child: ListTile(
                 leading: Icon(Icons.search,color: Colors.blueGrey,),
                 title: TextField(
                   decoration: InputDecoration(
                       hintText: "Search any Food",
                       border: InputBorder.none
                   ),
                   onChanged: (string) {
                        setState(() {
                          filteredUsers = foodNotifier.foodList
                              .where((u) => (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                              u.category.toLowerCase().contains(string.toLowerCase())))
                              .toList();
                        });
                   },

                 ),

               )
           ),
           Container(
             height: 480,
             child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: filteredUsers.length,
                itemBuilder: (_,index) {
                  return Stack(children: <Widget>[
                    Container(

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(filteredUsers[index].image),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8, bottom: 8, right: 8,
                      child: Container(
                        height: 60,
                        width: 360,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black, Colors.black12],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topCenter
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 15, bottom: 10, right: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //Text("Hot Coffee",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
                            Column(
                              children: <Widget>[
                                Text(filteredUsers[index].name, style: TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),),
                                Row(children: <Widget>[
                                  Icon(Icons.star, size: 12, color: Colors.blue,),
                                  Icon(Icons.star, size: 12, color: Colors.blue,),
                                  Icon(Icons.star, size: 12, color: Colors.blue,),
                                  Icon(Icons.star, size: 12, color: Colors.blue,),
                                  Icon(
                                    Icons.star_border, size: 12, color: Colors.blue,),
                                  Text('  (10.0 reviewer)',
                                    style: TextStyle(color: Colors.yellow),)

                                ],)
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text("20.0", style: TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),),
                                Text("Min Order")
                              ],
                            ),

                          ],
                        )
                    )


                  ],

                  );
                }
             ),
           ),
         ],
       );


  }

}