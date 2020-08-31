import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/models/category.dart';
import 'package:flutter_food_delivery/pages/CategoriesPage.dart';
List<Category> categoriesList =[
  Category(name: "Burger",    url: "assets/images/burger.png",    number: 12),
  Category(name: "Pizza",     url: "assets/images/pizza.png",     number: 10),
  Category(name: "Beer",      url: "assets/images/beer.png",      number: 7),
  Category(name: "Coffee-Cup",url: "assets/images/coffee-cup.png",number: 2),
  Category(name: "Turkey",    url: "assets/images/turkey.png",    number: 9),
];

class Categories extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Container(
     height: 120,
     child: ListView.builder(
       scrollDirection: Axis.horizontal,
       itemCount:categoriesList.length,
       itemBuilder: (_,index){
         return Column(
           children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 decoration: BoxDecoration(
                     color: Colors.white,
                     boxShadow: [BoxShadow(
                         color: Colors.grey,
                         offset: Offset(1, 1),
                         blurRadius: 4
                     )],
                    // borderRadius: BorderRadius.circular(20)
                 ),
                 child: Stack(children: <Widget>[
                   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       RaisedButton(
                          color: Colors.white,
                           onPressed:() {
                             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CategoriesPage()));
                           },
                           child: Image.asset(categoriesList[index].url,width: 50,)

                          ),
                       // Text('${categoriesList[index].number} kinds',style: TextStyle(fontWeight: FontWeight.bold),)
                     ],
                   )
                 ],),
               ),
             ),
             Text(categoriesList[index].name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)

           ],
         );
       },


     ),
   );
  }
  
}