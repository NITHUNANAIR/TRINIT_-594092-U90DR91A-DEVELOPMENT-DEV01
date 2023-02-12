import 'dart:convert';

import 'package:ngos/src/models/payment_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class DonorModel extends Model {
  List<Donor> _donor = [];
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<Donor> get donor {
    return List.from(_donor);
  }

  int get donorLength {
    return _donor.length;
  }

  Future<bool> addDonor(Donor donor) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> donorData = {
        "title": donor.name,
        "description": donor.description,
        "categoryOfNGOs": donor.categoryOfNGOs,
        "amount": donor.amount,
        "Donations": donor.donations,
      };
      final http.Response response = await http.post(
          "https://flutter-donor-a2151.firebaseio.com/donor.json",
          body: json.encode(donorData));

      final Map<String, dynamic> responeData = json.decode(response.body);

      Food donorWithID = Donor(
        id: responeData["name"],
        name: donor.name,
        description: donor.description,
        category: donor.category,
        discount: donor.discount,
        price: donor.price,
      );

      _donor.add(donorWithID);
      _isLoading = false;
      notifyListeners();
      // fetchDonors();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
      // print("Connection error: $e");
    }
  }

  Future<bool> fetchDonors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http
          .get("https://flutter-donor-a2151.firebaseio.com/donor.json" as Uri);

      // print("Fecthing data: ${response.body}");
      final Map<String, dynamic> fetchedData = json.decode(response.body);
      print(fetchedData);

      final List<NGOs> ngos = [];

      fetchedData.forEach((String id, dynamic ngos) {
        NGOs ngos = NGOs(
          id: id,
          name: ngosData["title"],
          description: ngosData["description"],
          category: ngosData["category"],
          price: double.parse(ngosData["price"].toString()),
          discount: double.parse(ngosData["discount"].toString()),
        );

        ngos.add(ngos);
      });

      _ngo = ngoList;
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("The errror: $error");
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> updateList(Map<String, dynamic> foodData, String foodId) async {
    _isLoading = true;
    notifyListeners();

    // get the food by id
    ngos = getFoodItemById(foodId) as Food;

    // get the index of the food
    int foodIndex = _foods.indexOf(theFood);
    try {
      await http.put(
          "https://flutter-food-a2151.firebaseio.com/foods/${foodId}.json" as Uri,
          body: json.encode(foodData));

      Food updateFoodItem = Food(
        id: foodId,
        name: foodData["title"],
        category: foodData["category"],
        discount: foodData['discount'],
        price: foodData['price'],
        description: foodData['description'],
      );

      _foods[foodIndex] = updateFoodItem;

      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> deleteFood(String foodId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.delete(
          "https://flutter-food-a2151.firebaseio.com/foods/${foodId}.json" as Uri);

      // delete item from the list of food items
      _foods.removeWhere((Food food) => food.id == foodId);

      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  bool getFoodItemById(String foodId) {
    bool food;
    for (int i = 0; i < _foods.length; i++) {
      if (_foods[i].id == foodId) {
        food = _foods[i] as bool;
        break;
      }
    }
    return food;
  }
}

class Food {
  get name => null;
  
  get description => null;
  
  get category => null;
  
  get price => null;
  
  get discount => null;
  
  get id => null;
}
