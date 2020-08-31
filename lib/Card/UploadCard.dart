
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class UploadCard extends StatefulWidget{
  final bool isUpdating;

  UploadCard ({ this.isUpdating});

  @override
  _UploadCardState createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Food _currentFood;
  String _imageUrl;
  File _imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    if(foodNotifier.currentFood!=null){
      _currentFood=foodNotifier.currentFood;
    }else{
      _currentFood=new Food();
    }
    _imageUrl = _currentFood.image;
  }
  _showImage(){
    if(_imageUrl==null && _imageFile ==null )
    {return Image.network('https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',height:300, width: 300,fit: BoxFit.fitHeight,);}
    else if( _imageFile !=null){
      print('showing image from local');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
              _imageFile ,
              fit: BoxFit.cover,
              height:250),
          FlatButton(onPressed: ()=> _getLocalImage(), child: Text('Change Image',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),))
        ],
      );
    }
    else if( _imageUrl !=null){
      print('showing image from url');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              height:250),
          FlatButton(onPressed: ()=> _getLocalImage(), child: Text('Change Image',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),))
        ],
      );
    }
  }
  _getLocalImage() async {
    final _picker = ImagePicker();
    final imageFile =
    // ignore: deprecated_member_use
    await _picker.getImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);


    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }
  _onFoodUploaded(Food food) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    foodNotifier.addFood(food);
    Navigator.pop(context);
  }
  _saveFood() {
    print('saveFood Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');



    uploadFoodAndImage(_currentFood, widget.isUpdating, _imageFile, _onFoodUploaded);

    print("name: ${_currentFood.name}");
    print("category: ${_currentFood.category}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }
  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentFood.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value)
      {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.name = value;
      },
    );
  }
  Widget _buildCategoryField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentFood.category,
      keyboardType: TextInputType.text,
      style:  TextStyle(fontSize: 20),
      validator: (String value){
        if(value.isEmpty){
          return 'Category is required';
        }
        if(value.length<3 || value.length >20){
          return 'Category must 3-20';
        }
        return null;
      },
      onSaved: (String value){
        _currentFood.category = value;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  _showImage(),
                  SizedBox(height: 16,),
                  Text( widget.isUpdating ? "Edit Food" : "Create Food",textAlign: TextAlign.center,style: TextStyle(fontSize: 30),),

                  ButtonTheme(
                    child: RaisedButton(
                      onPressed: () => _getLocalImage(),
                      child: Text('Add Image',style: TextStyle(color: Colors.white),),
                    ),
                  ) ,
                  _buildNameField(),
                  _buildCategoryField(),
                  SizedBox(height: 16,)
//
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveFood();
          Toast.show("Saved", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

}


