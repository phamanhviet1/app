import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/models/ListItem.dart';

class FoodNotifier with ChangeNotifier {
  List<Food> _foodList = [];
  Food _currentFood;

  UnmodifiableListView<Food> get foodList => UnmodifiableListView(_foodList);

  Food get currentFood => _currentFood;

  set foodList(List<Food> foodList) {
    _foodList = foodList;
    notifyListeners();
  }

  set currentFood(Food food) {
    _currentFood = food;
    notifyListeners();
  }

  addFood(Food food) {
    _foodList.insert(0, food);
    notifyListeners();
  }

  deleteFood(Food food) {
    _foodList.removeWhere((_food) => _food.id == food.id);
    notifyListeners();
  }

  List<Food> _cardList = [];
  Food _orderFood;

  UnmodifiableListView<Food> get cardList => UnmodifiableListView(_cardList);

  Food get orderFood => _orderFood;

  set cardList(List<Food> cardList) {
    _cardList = cardList;
    notifyListeners();
  }

  set orderFood(Food food) {
    _orderFood = food;
    notifyListeners();
  }

  addCard(Food food) {
    _cardList.insert(0, food);
    notifyListeners();
  }

  deleteCard(Food food) {
    _cardList.removeWhere((_food) => _food.id == food.id);
    notifyListeners();
  }

  List<Food> _orderList = [];
  Food _orderitem;
  Infor _infor;
  Infor get infor => _infor;
  set infor(Infor infor) {
    _infor = infor;
    notifyListeners();
  }
  UnmodifiableListView<Food> get orderList => UnmodifiableListView(_orderList);

  Food get orderitem => _orderitem;


  set orderList(List<Food> orderList) {
    _orderList = orderList;
    notifyListeners();
  }

  set orderitem(Food food) {
    _orderitem = food;
    notifyListeners();
  }

  addItem(Food food) {
    _orderList.insert(0, food);
    notifyListeners();
  }

  deleteItem(Food food) {
    _orderList.removeWhere((_food) => _food.id == food.id);
    notifyListeners();
  }


}
