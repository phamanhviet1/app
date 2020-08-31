import 'package:cloud_firestore/cloud_firestore.dart';
class Food {

  String name;
  String category;
  String image;
  List subIngredients = [];
  Timestamp createdAt;
  Timestamp updatedAt;
  String id;
  String flag;
  Food();

  Food.fromMap(Map<String, dynamic> data) {

    name = data['name'];
    category = data['category'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    id = data['id'];
    flag = data['flag'];
  }
  Map<String, dynamic> toMap() {
    return {

      'name': name,
      'category': category,
      'image': image,
      'subIngredients': subIngredients,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
      'flag' : flag
    };
  }
}

