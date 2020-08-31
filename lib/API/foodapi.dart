import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/models/Auth.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/foodnotifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/ListItem.dart';

login(Auth auth, AuthNotifier authNotifier) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  print("singin");
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final AuthResult result =
      await _firebaseAuth.signInWithCredential(credential);
  if (result != null) {
    FirebaseUser firebaseUser = result.user;

    if (firebaseUser != null) {
      print("Log In: ${firebaseUser.displayName}");
      authNotifier.setUser(firebaseUser);
    }
    else print("error");
  }
  else print("error");

}

signout(AuthNotifier authNotifier) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  await _firebaseAuth.signOut().catchError((error) => print(error.code));
  await googleSignIn.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print('log in $firebaseUser');
    authNotifier.setUser(firebaseUser);
  }

}

getFoods(FoodNotifier foodNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('Foods').getDocuments();

  List<Food> _foodList = [];

  snapshot.documents.forEach((document) {
    Food food = Food.fromMap(document.data);
    _foodList.add(food);
  });

  foodNotifier.foodList = _foodList;
}

uploadFoodAndImage(
    Food food, bool isUpdating, File localFile, Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('foods/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadFood(food, isUpdating, foodUploaded);
  }
}

_uploadFood(Food food, bool isUpdating, Function foodUploaded,
    {String imageUrl}) async {
  CollectionReference foodRef = Firestore.instance.collection('Foods');

  if (imageUrl != null) {
    food.image = imageUrl;
  }

  if (isUpdating) {
    food.updatedAt = Timestamp.now();

    await foodRef.document(food.id).updateData(food.toMap());

    foodUploaded(food);
    print('updated food with id: ${food.id}');
  } else {
    food.createdAt = Timestamp.now();

    DocumentReference documentRef = await foodRef.add(food.toMap());

    food.id = documentRef.documentID;

    print('uploaded food successfully: ${food.toString()}');

    await documentRef.setData(food.toMap(), merge: true);

    foodUploaded(food);
  }
}

deleteFood(Food food, Function foodDeleted) async {
  if (food.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(food.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('Foods').document(food.id).delete();
  foodDeleted(food);
}

// ignore: non_constant_identifier_names
UploadOrderCard(Food food, String email) async {
  CollectionReference foodRef = Firestore.instance.collection(email);
  food.createdAt = Timestamp.now();
  DocumentReference documentRef = await foodRef.add(food.toMap());

  food.id = documentRef.documentID;

  print('Order food successfully: ${food.toString()}');

  await documentRef.setData(food.toMap(), merge: true);
}

addPhone(String user,String phone) async {
  try {
    DocumentReference foodRef = Firestore.instance.collection("$user").document("user");
    foodRef.updateData({"Phone": "$phone",});

    print('user ${user.toString()}');
    return user;
  } catch (error) {
    return null;
  }
}
addAddress(String user,String address) async {
  try {
    DocumentReference foodRef = Firestore.instance.collection("$user").document("user");
    foodRef.updateData({"Address": "$address",});
    print('user ${user.toString()}');
    return user;
  } catch (error) {
    return null;
  }
}

 getOrder(FoodNotifier foodNotifier, String displayname ,List cartname) async {

  QuerySnapshot snapshot =
      await Firestore.instance.collection(displayname).getDocuments();

  List<Food> _foodOrder = [];

  snapshot.documents.forEach((document) {
    Food food = Food.fromMap(document.data);

    _foodOrder.add(food);
    if (cartname.indexOf(food.flag) == -1 && food.flag!="1")
       cartname.add(food.flag);


  });
      foodNotifier.orderList = _foodOrder;
        print("ok");
       print('getcart ${cartname.length}');

}

getcart(FoodNotifier foodNotifier, List cartname) async  {
  for (var i = 0; i < foodNotifier.orderList.length; i++) {
    if (cartname.indexOf(foodNotifier.orderList[i].flag) == -1 && foodNotifier.orderList[i].flag!="1")
      cartname.add(foodNotifier.orderList[i].flag);
      }
  print('getcart ${cartname.length}');
}

getInfor(FoodNotifier foodNotifier,String user) async{
  Infor inf;
  QuerySnapshot snapshot =
  await Firestore.instance.collection(user).getDocuments();
  snapshot.documents.forEach((document) {
    if (document.documentID =="user")
        inf = Infor.fromMap(document.data);
  });

    if(inf==null)Firestore.instance.collection(user).document("user").setData({"flag": "1"});
    foodNotifier.infor =inf;
    print("infor changed ${foodNotifier.infor.flag}");

}
