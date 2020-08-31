
import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/Screen/SplashScreen.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:random_string/random_string.dart';
import '../models/Food.dart';
import 'package:toast/toast.dart';
import '../models/ListItem.dart';
import '../models/Auth.dart';
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
  Infor _infor =null;
  Auth _auth;

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
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(this.context, listen: false);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(this.context,listen: false);
    getOrder(foodNotifier,  authNotifier.user.email ,cartname);
    getInfor(foodNotifier, authNotifier.user.email);

    if(foodNotifier.infor!=null){
      _infor=foodNotifier.infor;
    }else{
      _infor=new Infor();
    }

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
  void  _showDialogPhone(String value,user){

  // return object of type Dialog
    AlertDialog alertDialog = new AlertDialog(
        title: new Text("Alert Dialog title"),
        content:TextFormField(

          initialValue: value ,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          style:  TextStyle(fontSize: 20),
          decoration: InputDecoration(
          labelText: 'Phone',

          ),
          onChanged: (String save){
            value = save;
            print('onchanged $value');
          },
        ),
          actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
            Navigator.of(context).pop();
            },
            ),
            new FlatButton(
              child: new Text(value != null ?"Update":"Create"),
              onPressed: () {
                  setState(() {
                    addPhone( user, value)!= null?  _infor.phone= value:print("eror");
                  });
                  Navigator.of(context).pop();
                },
            ),
            ],
          );
             showDialog(context: context,builder: (BuildContext context) => alertDialog);
          }
  void  _showDialogAddress(String value,user){

    // return object of type Dialog
    AlertDialog alertDialog = new AlertDialog(
      title: new Text("Alert Dialog title"),
      content:TextFormField(

        initialValue: value ,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        style:  TextStyle(fontSize: 20),
        decoration: InputDecoration(
          labelText: 'Address',

        ),
        onChanged: (String save){
          value = save;
          print('onchanged $value');
        },
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text(value != null ?"Update":"Create"),
          onPressed: () {

                  addAddress( user, value );
                  _infor.address= value;



                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreen(returnPage: 3,)));
          },
        ),
      ],
    );
    showDialog(context: context,builder: (BuildContext context) => alertDialog);
  }


  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context,listen: false);
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context,);
    // getcart(foodNotifier, cartname);


      _infor=foodNotifier.infor;
      print(_infor);
    //tham số e là tênlỗi muốn xử lý

    //Chương trình thực hiện khi gặp lỗi trên

      Widget _builderItem() {
      List<Food> cart = [];
      foodNotifier.orderList.forEach((element) {
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
        if(_infor!=null) {
          return Scaffold(

           appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: Text("Profile ")),
              actions:<Widget>[

                MaterialButton(
                    onPressed: () {
                      getOrder(foodNotifier, authNotifier.user.email,cartname);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) {
                        return MainScreen(
                          returnPage: 3,
                        );
                      }));
                      print("total ${foodNotifier.orderList.length}");
                    },
                    child: Icon(Icons.refresh)),
              ]
            ),

            body: Padding(
            padding: const EdgeInsets.all(8.0),
              child:  ListView(
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                    SizedBox(
                    height: 20,),

                      Row(
                        children: [
                          Icon((Icons.person)),
                          Text(
                            " Account: ${authNotifier.user.displayName}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          FlatButton(
                            onPressed: (){
                              signout(authNotifier).whenComplete(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInPage())));
                            },
                            child: Card(child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children: [
                                  Text("Log Out "),
                                  Icon(Icons.exit_to_app),
                                ],
                              ),
                            )),
                          ),
                        ],
                      ),

                      Divider(color: Colors.white,
                        thickness: 2,height: 30,
                       ),
                      Row(children: [
                         Icon((Icons.home)),
                        GestureDetector(
                          onTap:()  {

                            _showDialogAddress(_infor.address,authNotifier.user.email);

                          },
                          child:Text(" Address  : ",
                              style: TextStyle(color: Colors.white, fontSize: 20)),

                        ),
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(fontSize: 20.0),
                            text: TextSpan(
                                style: TextStyle(color: Colors.black ,fontSize: 15.0),
                                text: '${_infor.address }'),
                          ),
                        ),
                      ]),
                      Divider(color: Colors.white,
                        thickness: 2,height: 30,
                      ),
                      Row(
                          children: [
                        Icon((Icons.phone)),
                        GestureDetector(
                            onTap:()  {

                             _showDialogPhone(_infor.phone,authNotifier.user.email);

                            },
                          child:Text(" Phone      : ",
                              style: TextStyle(color: Colors.white, fontSize: 20)),

                        ),
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 20.0),
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black ,fontSize: 15.0),
                                    text: '${_infor.phone }'),
                              ),
                            ),
                      ]),
                      Divider(color: Colors.white,
                        thickness: 2,height: 30,
                      ),
                      Row(children: [
                        Icon((Icons.shopping_cart )),
                        Text(" Cart Order",
                            style:
                            TextStyle(color: Colors.white, fontSize: 20)),
                      ]),
                      SizedBox(
                        height: 20,),
                    ],
                  ),
                ),
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
                    await  getOrder(foodNotifier, authNotifier.user.email ,cartname);
                    setState(() {
                        getcart(foodNotifier, cartname);

                    });

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
        } else return SplashScreen();
      }
    }


